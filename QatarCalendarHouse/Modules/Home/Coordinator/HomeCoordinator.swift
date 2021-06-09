//
//  HomeCoordinator.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/30/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit
import SideMenu

class HomeCoordinator: Coordinator {
    private let presenter: Router
    private var homeVC: HomeVC?
    private var sideMenuCoordinator: SideMenuCoordinator

    init(presenter: Router) {
        self.presenter = presenter
        sideMenuCoordinator = SideMenuCoordinator(presenter: presenter)
        SideMenuManager.default.rightMenuNavigationController = sideMenuCoordinator.menuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: presenter.navigationController.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: presenter.navigationController.view)
    }

    func start() {
        let home = HomeVC.instantiate()
        home.delegate = self
        presenter.push(home, animated: false, completion: nil)
        self.homeVC = home
    }
}

extension HomeCoordinator: HomeDelegate {
    
    func gotoDayContent(_ content: String) {
        let coordinator = TextDetailsCoordinator(presenter: self.presenter, title: "محتوى اليوم", details: content)
        coordinator.start()
    }
    
    func gotoAbout() {
        let coordinator = AboutCoordinator(presenter: self.presenter)
        coordinator.start()
    }
    
    func gotoSideMenu() {
        sideMenuCoordinator.start()
    }
    
    func gotoMonthlyCalendar(for type: CalendarType, date: Date = Date()) {
        let coordinator = MonthlyCalendarCoordinator(presenter: self.presenter, type: type, date: date)
        coordinator.start()
    }
    
    func gotoAstrologicalDetails(type: AstrologicalType) {
        let coordinator = AstrologicalDetailsCoordinator(presenter: self.presenter, type: type)
        coordinator.start()
    }
    
    func gotoSettings() {
        let coordinator = NotificationsCoordinator(presenter: self.presenter)
        coordinator.start()
    }
}

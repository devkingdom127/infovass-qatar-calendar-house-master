//
//  SideMenuCoordinator.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/31/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuCoordinator: Coordinator {
    private let presenter: Router
    private var sideMenuVC: SideMenuVC
    private var children = [Coordinator]()
    var menuNavigationController: SideMenuNavigationController

    init(presenter: Router) {
        self.presenter = presenter
        sideMenuVC = SideMenuVC.instantiate()
        menuNavigationController = SideMenuNavigationController(rootViewController: sideMenuVC)
        menuNavigationController.menuWidth = presenter.navigationController.view.bounds.width * 0.7
        menuNavigationController.setNavigationBarHidden(true, animated: false)
        sideMenuVC.delegate = self
    }
    
    func start() {
        presenter.present(menuNavigationController, animated: true)
    }
}

extension SideMenuCoordinator: SideMenuDelegate {
    func gotoMonthlyCalendar() {
        let coordinator = MonthlyCalendarCoordinator(presenter: self.presenter, type: .prayerTimes)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoHome() {
        sideMenuVC.dismiss(animated: true, completion: nil)
    }
    
    func gotoQibla() {
        let coordinator = QiblaCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoPrayerTimes() {
        let coordinator = PrayerTimesCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoVacations() {
        let coordinator = VacationsCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoNotifications() {
        let coordinator = NotificationsCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoRamadan() {
        let coordinator = RamadanCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoCalendars() {
        let coordinator = CalendarCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoBorgAndTalaAndSuhail() {
        let coordinator = BorgAndTalaAndSuhailCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoAllContent() {
        let coordinator = AllContentCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoAboutUs() {
        let coordinator = AboutCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
    func gotoContactUs() {
        let coordinator = ContactUsCoordinator(presenter: self.presenter)
        sideMenuVC.dismiss(animated: true) {
            coordinator.start()
        }
    }
    
}

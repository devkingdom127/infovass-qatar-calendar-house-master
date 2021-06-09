//
//  AppDataLoaderCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/19/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

class AppDataLoaderCoordinator: Coordinator {
    private let presenter: Router
    private var controller: AppDataLoaderVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = AppDataLoaderVC.instantiate()
        controller.delegate = self
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

extension AppDataLoaderCoordinator: AppDataLoaderDelegate {
    func gotoHome() {
        let coordinator = HomeCoordinator(presenter: self.presenter)
        coordinator.start()
    }
}

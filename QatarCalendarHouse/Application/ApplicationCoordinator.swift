//
//  ApplicationCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/7/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let rootViewController: UINavigationController
    let router: QCHRouter
    let window: UIWindow
    let startCoordinator: HomeCoordinator
    let applicationContentModel: ApplicationContentModel

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = MainVC.instantiate()
        router = QCHRouter(navigationController: rootViewController)
        startCoordinator = HomeCoordinator(presenter: router)
        applicationContentModel = ApplicationContentModel()
    }

    func start() {
        window.rootViewController = router.toShowable()
        startCoordinator.start()
        window.makeKeyAndVisible()
        _ = applicationContentModel.configure()
    }
}

//
//  NotificationsCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class NotificationsCoordinator: Coordinator {
    private let presenter: Router
    private var controller: NotificationsVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = NotificationsVC.instantiate()
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

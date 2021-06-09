//
//  QiblaCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

class QiblaCoordinator: Coordinator {
    private let presenter: Router
    private var controller: QiblaVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = QiblaVC.instantiate()
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

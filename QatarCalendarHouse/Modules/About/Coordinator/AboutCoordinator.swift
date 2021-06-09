//
//  AboutCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AboutCoordinator: Coordinator {
    private let presenter: Router
    private var controller: AboutVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = AboutVC.instantiate()
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

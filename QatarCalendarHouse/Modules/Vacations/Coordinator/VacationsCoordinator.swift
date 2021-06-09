//
//  VacationsCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class VacationsCoordinator: Coordinator {
    private let presenter: Router
    private var controller: VacationsVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let vacations = VacationsVC.instantiate()
        presenter.push(vacations, animated: false, completion: nil)
        self.controller = vacations
    }
}

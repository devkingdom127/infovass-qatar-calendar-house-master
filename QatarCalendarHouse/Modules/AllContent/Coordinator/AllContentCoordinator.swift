//
//  AllContentCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/28/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AllContentCoordinator: Coordinator {
    private let presenter: Router
    private var controller: AllContentVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let vacations = AllContentVC.instantiate()
        presenter.push(vacations, animated: false, completion: nil)
        self.controller = vacations
    }
}

//
//  CalendarCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class CalendarCoordinator: Coordinator {
    private let presenter: Router
    private var controller: CalendarVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = CalendarVC.instantiate()
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

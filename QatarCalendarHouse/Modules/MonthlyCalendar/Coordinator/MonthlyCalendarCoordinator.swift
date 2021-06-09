//
//  MonthlyCalendarCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class MonthlyCalendarCoordinator: Coordinator {
    private let presenter: Router
    private var controller: MonthlyCalendarVC?
    private let type: CalendarType
    private let date: Date

    init(presenter: Router, type: CalendarType, date: Date = Date()) {
        self.presenter = presenter
        self.type = type
        self.date = date
    }

    func start() {
        let controller = MonthlyCalendarVC.instantiate()
        controller.type = type
        controller.date = date
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

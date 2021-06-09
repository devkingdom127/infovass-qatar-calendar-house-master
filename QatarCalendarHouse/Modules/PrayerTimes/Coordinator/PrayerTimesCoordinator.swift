//
//  PrayerTimesCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class PrayerTimesCoordinator: Coordinator {
    private let presenter: Router
    private var controller: PrayerTimesVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = PrayerTimesVC.instantiate()
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

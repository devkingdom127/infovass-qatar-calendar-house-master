//
//  ContactUsCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class ContactUsCoordinator: Coordinator {
    private let presenter: Router
    private var controller: ContactUsVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = ContactUsVC.instantiate()
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

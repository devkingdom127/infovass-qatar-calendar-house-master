//
//  BorgAndTalaAndSuhailCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class BorgAndTalaAndSuhailCoordinator: Coordinator {
    private let presenter: Router
    private var controller: BorgAndTalaAndSuhailVC?

    init(presenter: Router) {
        self.presenter = presenter
    }

    func start() {
        let controller = BorgAndTalaAndSuhailVC.instantiate()
        controller.delegate = self
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

extension BorgAndTalaAndSuhailCoordinator: BorgAndTalaAndSuhailDelegate {
    func gotoAstrologicalDetails(content: Astrological) {
        let coordinator = AstrologicalDetailsCoordinator(presenter: self.presenter, content: content)
        coordinator.start()
    }
}

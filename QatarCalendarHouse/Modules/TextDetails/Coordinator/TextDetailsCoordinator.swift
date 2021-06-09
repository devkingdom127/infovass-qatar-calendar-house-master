//
//  TextDetailsCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 5/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

class TextDetailsCoordinator: Coordinator {
    private let presenter: Router
    private var controller: TextDetailsVC?
    private let title: String?
    private let details: String
    
    init(presenter: Router, title: String? = nil, details: String) {
        self.presenter = presenter
        self.title = title
        self.details = details
    }
    
    func start() {
        let controller = TextDetailsVC.instantiate()
        controller.titleStr = title
        controller.details = details
        self.controller = controller
        presenter.push(controller, animated: true, completion: nil)
    }
}

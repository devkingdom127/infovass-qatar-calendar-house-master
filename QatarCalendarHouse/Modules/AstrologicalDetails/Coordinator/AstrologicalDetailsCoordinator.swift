//
//  AstrologicalDetailsCoordinator.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AstrologicalDetailsCoordinator: Coordinator {
    private let presenter: Router
    private var controller: AstrologicalDetailsVC?
    private let type: AstrologicalType?
    private let content: Astrological?

    init(presenter: Router, type: AstrologicalType? = nil, content: Astrological? = nil) {
        self.presenter = presenter
        self.type = type
        self.content = content
    }
    
    func start() {
        let controller = AstrologicalDetailsVC.instantiate()
        var model: AstrologicalDetailsModel?
        if let type = type {
            model = AstrologicalDetailsModel(type: type)
        } else if let content = content {
            model = AstrologicalDetailsModel(astrological: content)
        }
        controller.model = model
        presenter.push(controller, animated: false, completion: nil)
        self.controller = controller
    }
}

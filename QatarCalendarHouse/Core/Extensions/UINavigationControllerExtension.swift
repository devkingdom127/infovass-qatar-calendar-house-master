//
//  UINavigationController.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/31/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit

extension UINavigationController {
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}

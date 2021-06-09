//
//  Router.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/30/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit


protocol Router {
    
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    func present(_ module: Showable, animated: Bool)
    func push(_ module: Showable, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    func fade(to viewController: UIViewController)
}

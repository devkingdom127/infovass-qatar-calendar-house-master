//
//  Storyboarded.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/30/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: className.replacingOccurrences(of: "VC", with: ""), bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! Self
    }
}

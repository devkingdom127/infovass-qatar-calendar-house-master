//
//  Showable.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/30/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import UIKit

protocol Showable {
  
  func toShowable() -> UIViewController
  
}

extension UIViewController: Showable {
  public func toShowable() -> UIViewController {
    return self
  }
}

//
//  UIStackViewExtension.swift
//  Nursery
//
//  Created by Amr Salman on 8/3/19.
//  Copyright © 2019 infovass. All rights reserved.
//

import UIKit

extension UIStackView {
    func setView(_ views: [UIView], gone: Bool, animated: Bool, duration: Double = 0.3) {
        if animated {
            if gone {
                UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    for view in views {
                        view.alpha = 0
                    }
                }, completion: { fin in
                    if !fin { return }
                    for view in views {
                        view.isHidden = true
                    }
                    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                        self.superview!.layoutIfNeeded()
                    }, completion: nil)
                })
            } else {
                for view in views {
                    view.isHidden = false
                    view.alpha = 0
                }
                UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.superview!.layoutIfNeeded()
                }, completion: { fin in
                    if !fin { return }
                    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
                        for view in views {
                            view.alpha = 1
                        }
                    }, completion: nil)
                })
            }
        } else {
            for view in views {
                view.alpha = gone ? 0 : 1
                view.isHidden = gone ? true : false
            }
        }
    }
    
    func reverse() {
        var views  = self.arrangedSubviews
        
        for view in views {
            self.removeArrangedSubview(view)
        }
        
        views.reverse()
        
        for (index, view) in views.enumerated() {
            self.insertArrangedSubview(view, at: index)
        }
    }
}

//
//  UIViewExtension.swift
//  Kotobi
//
//  Created by Amr Salman on 11/9/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public enum Shape {
    case rectangle
    case rounded(CGFloat)
    case circular
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return self.borderColor
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return self.shadowColor
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    var shape: Shape? {
        get {
            return self.shape
        }
        
        set {
            setShape(newValue!)
        }
    }
    
    func setShape(_ shape: Shape) {
        switch shape {
        case .circular:
            circulerContent()
        case .rounded(let cornerRadius):
            self.cornerRadius = cornerRadius
        case .rectangle:
            self.cornerRadius = 0
        }
    }
    
    public func circulerContent() {
        self.cornerRadius = self.bounds.height / 2
        layer.masksToBounds = true
    }
    
    func setShadow(color: UIColor = .black, radius: CGFloat = 2, opacity: Float = 0.15, offset: CGSize = CGSize(width: 0, height: 1)) {
        shadowColor = color
        shadowRadius = radius
        shadowOpacity = opacity
        shadowOffset = offset
    }
    
    func shadowView(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) -> UIView {
        let shadowView = UIView()
        shadowView.frame = self.frame
        shadowView.shadowColor = color
        shadowView.shadowOffset = offset
        shadowView.shadowRadius = radius
        shadowView.shadowOpacity = opacity
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        return shadowView
    }
    
    func shadowView(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize = CGSize(width: 0 , height: 0), shape: Shape) -> UIView {
        let shadowView = UIView()
        shadowView.frame = self.frame
        shadowView.shadowColor = color
        shadowView.shadowOffset = offset
        shadowView.shadowRadius = radius
        shadowView.shadowOpacity = opacity
        switch shape {
        case .rectangle, .circular:
            shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        case .rounded(let cornerRadius):
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius).cgPath
        }
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        self.shape = shape
        return shadowView
    }
    
    func fadeIn(_ view: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.transition(with: view, duration: duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            view.isHidden = false
        }, completion: completion)
    }
    
    func fadeOut(_ view: UIView, duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.transition(with: view, duration: duration, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            view.isHidden = true
        }, completion: completion)
    }
    
    func addShadowLayer() {
        let baseView = UIView()
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        baseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        baseView.layer.shadowOpacity = 0.2
        baseView.layer.shadowRadius = 5
        self.insertSubview(baseView, at: 0)
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

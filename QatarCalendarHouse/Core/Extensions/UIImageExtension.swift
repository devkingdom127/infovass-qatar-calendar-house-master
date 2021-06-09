//
//  UIImageExtension.swift
//  Kotobi
//
//  Created by Amr Salman on 11/9/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func with(color: UIColor) -> UIImage {
        guard let cgImage = self.cgImage else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: imageRect, mask: cgImage)
        color.setFill()
        context.fill(imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}

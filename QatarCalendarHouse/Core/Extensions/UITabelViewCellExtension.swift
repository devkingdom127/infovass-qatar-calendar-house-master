//
//  UITabelViewCellExtension.swift
//  BaitAladl
//
//  Created by Amr Salman on 30/5/19.
//  Copyright © 2019 infovass. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func fadeAnimation(_ indexPath: IndexPath) {
        self.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                self.alpha = 1
        })
    }
}

extension UICollectionViewCell {
    func fadeAnimation(_ indexPath: IndexPath) {
        self.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                self.alpha = 1
        })
    }
}

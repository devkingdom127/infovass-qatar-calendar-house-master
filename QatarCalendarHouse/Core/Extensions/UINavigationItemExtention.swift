//
//  UINavigationItemExtention.swift
//  MyCommunity
//
//  Created by Kerolos Fahem on 3/20/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import UIKit

//Csutom Back Btn
extension UINavigationItem{
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        
        if let font = UIFont(name: "Copperplate-Light", size: 32){
            backItem.setTitleTextAttributes([NSAttributedString.Key.font:font], for: .normal)
        }else{
            print("Font Not available")
        }
        /*Changing color*/
        backItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        self.backBarButtonItem = backItem
    }
    
}

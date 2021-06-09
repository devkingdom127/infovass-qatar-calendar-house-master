//
//  StringExtension2.swift
//  QatarCalendarHouse
//
//  Created by Moahmmed Sami on 20/12/2020.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

extension String {
    
    func isURL () -> Bool {
        
        if let url  = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}

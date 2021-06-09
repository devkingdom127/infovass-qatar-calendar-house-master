//
//  DoubleExtension.swift
//  MyCommunity
//
//  Created by Amr Salman on 3/10/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

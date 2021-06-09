//
//  IntExtension.swift
//  Nursery
//
//  Created by Amr Salman on 20/2/19.
//  Copyright © 2019 infovass. All rights reserved.
//

import Foundation

extension Int {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    func toArabicNumbers() -> String {
        let format = NumberFormatter()
        format.locale = Locale(identifier: "ar_sa")
        let number = NSNumber(integerLiteral: self)
        let arNumber = format.string(from: number)
        return arNumber!

    }
}

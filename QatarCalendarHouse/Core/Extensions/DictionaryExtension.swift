//
//  DictionaryExtension.swift
//  MyCommunity
//
//  Created by Amr Salman on 3/10/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func combine(withOther other: Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    
    func toString() -> String {
        var str = "{"
        self.forEach({str += "\"\($0)\": \"\($1)\","})
        str.removeLast()
        str += "}"
        return str
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}

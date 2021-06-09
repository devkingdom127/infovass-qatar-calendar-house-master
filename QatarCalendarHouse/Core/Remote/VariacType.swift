//
//  VariacType.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/19/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

enum VariacType:Codable{
    func encode(to encoder: Encoder) throws {
    }
    case int(Int)
    case string(String)
    init(from decoder: Decoder) throws {
        if let intValue = try? decoder.singleValueContainer().decode(Int.self)  {
            self = .int(intValue)
            return
        }
        if let stringValue = try? decoder.singleValueContainer().decode(String.self){
            self = .string(stringValue)
            return
        }
        throw VariacError.missingValue
    }
    enum VariacError: Error {
        case missingValue
    }
}
extension VariacType {
    var value: String {
        switch self {
        case .int(let intValue):
            return String(intValue)
        case .string(let stringValue):
            return stringValue
        }
    }
}

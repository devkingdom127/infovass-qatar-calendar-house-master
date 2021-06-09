//
//  Response.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {
    
    //MARK: - Properties
    
    let list: [T]?
    var listSingleItem: T? {
        return list?.first
    }
    let value: T?
    let code: Int
    let message: String
    let version: VariacType
    
    enum CodingKeys: String, CodingKey {
        case list = "data"
        case value
        case code
        case message = "msg"
        case version
    }
}

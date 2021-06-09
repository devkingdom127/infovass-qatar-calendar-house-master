//
//  Astronomy.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

struct Astronomy: Codable {
    
    //MARK: - Properties
    
    let id : Int
    let definition : String?
    let title : String
    let file : String?
    let group : String
    let createdAt : String?
    let updatedAt : String?
    var type: ContentType? {
        ContentType(rawValue: group)
    }

    //MARK: - Initializers
        
    //MARK: - Helpers

}

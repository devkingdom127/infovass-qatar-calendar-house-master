//
//  TableVersion.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/18/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

struct TableVersion: Codable {
    
    //MARK: - Properties
    
    let id : Int
    let version : Int
    let tableName : String
    var table: Table? {
        return Table(rawValue: tableName)
    }

    //MARK: - Initializers
    
    
    //MARK: - Helpers
        
}

enum Table: String, CaseIterable {
    case years, abudhabi, kuwait, manama, muscat, makkah, almadinah, ryaid, borgTaleas = "borg_taleas", astronomies, contents, settings, vacations, capitals, borg, tala
}

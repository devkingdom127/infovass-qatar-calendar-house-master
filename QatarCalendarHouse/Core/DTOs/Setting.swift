//
//  Setting.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/13/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

enum SettingType: String, CaseIterable {
    case email, telephone, phone, fax, lat, lang, facebook,
         twitter, instagram, address, mailbox, website, youtube
}

struct Setting: Codable {
    
    //MARK: - Properties
    
    let id : Int
    let key : String
    let value : String?
    let createdAt : String?
    let updatedAt : String?
    
    //MARK: - Initializers
        
    //MARK: - Helpers
    

}

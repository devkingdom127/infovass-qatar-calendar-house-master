//
//  ContentItem.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/13/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

enum ContentType: String {
    case gregorianCalendar = "التقويم الميلادي"
    case hijriCalendar = "التقويم الهجري"
    case astronomicalSystems = "فلكيات منظومة"
    case astronomicalApprovals = "موافقات فلكية"
    case aboutUs = "نبذة عنا"
    case talasNote = "ملحوظة الطوالع"
    case borgsNote = "ملحوظة البروج"
    case suhail = "سهيل"
    case schoolCalndar = "التقويم المدرسي"
    case ramadan = "إمساكية رمضان"
}

struct ContentItem: Codable {
    
    //MARK: - Properties
    
    let id : Int
    let title : String
    let description : String?
    let referTo : String
    let image : String?
    let file : String?
    let createdAt : String?
    let updatedAt : String?
    var type : ContentType? {
        return ContentType(rawValue: self.referTo)
    }
    
    //MARK: - Initializers
    
    
    //MARK: - Helpers
    

}

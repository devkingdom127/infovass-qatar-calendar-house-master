//
//  DayCalender.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/13/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

struct DayCalendar: Codable, Equatable {
    
    //MARK: - Properties
    
    let id : Int
    let date : String
    let dayName : String?
    let fajr : String
    let shrouk : String
    let zuhr : String
    let asr : String
    let maghrib : String
    let eshaa : String
    let midNight : String?
    let lastThird : String?
    let mawasem : String?
    let suhail : String?
    let borgName : String?
    let borgNum : String?
    let talaName : String?
    let talaNum : String?
    let dayContent : String?
    let dayPhenomena : String?
    let hijriDate : String?
    let hijriYear : String?
    let hijriMonth : String?
    let hijriDay : String?
    let shoroukTime: String?
    let ghoroubTime: String?

    //MARK: - Initializers
    
    //MARK: - Helpers
    
}

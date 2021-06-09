//
//  DateExtension.swift
//  BaitAladl
//
//  Created by Amr Salman on 19/7/19.
//  Copyright © 2019 infovass. All rights reserved.
//

import Foundation

extension Date {
    var timeAgo: String {
        let components = dateComponents(from: Date())
        if (components.year! >= 2) {
            return "\(components.year!) \("years ago")"
        } else if (components.year! >= 1){
            return "Last year"
        } else if (components.month! >= 2) {
            return "\(components.month!) \("months ago")"
        } else if (components.month! >= 1){
            return "Last month"
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) \("weeks ago")"
        } else if (components.weekOfYear! >= 1){
            return "Last week"
        } else if (components.day! >= 2) {
            return "\(components.day!) \("days ago")"
        } else if (components.day! >= 1){
            return "Yesterday"
        } else if (components.hour! >= 2) {
            return "\(components.hour!) \("hours ago")"
        } else if (components.hour! >= 1){
            return "An hour ago"
        } else if (components.minute! >= 2) {
            return "\(components.minute!) \("minutes ago")"
        } else if (components.minute! >= 1){
            return "A minute ago"
        } else if (components.second! >= 3) {
            return "\(components.second!) \("seconds ago")"
        } else {
            return "Just now"
        }
    }
    
    func dateComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        let earliest = (date as NSDate).earlierDate(self)
        let latest = (earliest == date) ? self : date
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        return components
    }
    
    static func nextSevenDays() -> [Date]{
        return Date.next(numberOfDays: 7, from: Date())
    }
    
    static func next(numberOfDays: Int, from startDate: Date, availableWeekDays: [Int] = [1, 2, 3, 4, 5, 6, 7]) -> [Date]{
        var dates = [Date]()
        for i in 0..<numberOfDays {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: startDate) {
                let cal = Calendar(identifier: Calendar.Identifier.gregorian)
                guard availableWeekDays.contains(cal.component(.weekday, from: date)) else { continue }
                dates.append(date)
            }
        }
        return dates
    }

    func stringFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
    
    func hijriDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_SA")
        formatter.dateFormat = "d-MMMM-yyyy هـ"
        return formatter.string(from: self)
    }
    
    func gregorianDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_eg")
        formatter.dateFormat = "d-MMM-yyyy م"
        return formatter.string(from: self)
    }
    
    func alarmDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_eg")
        formatter.dateFormat = "EEEE d MMMM yyyy h:mm a"
        return formatter.string(from: self)
    }

    func arabicDayNameFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    func gregorianDayAndMonthDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d/M"
        return formatter.string(from: self)
    }

    func gregorianDayNumber() -> String {
        let cal = Calendar.init(identifier: .gregorian)
        let dateComp = cal.dateComponents([.day, .month], from: self)
        if dateComp.day == 1 {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ar_eg")
            formatter.dateFormat = "MMMM"
            return formatter.string(from: self)
        }
        return "\(dateComp.day ?? 0)"
    }
    
    func islamicDayNumber() -> String {
        let cal = Calendar.init(identifier: .islamicUmmAlQura)
        let dateComp = cal.dateComponents([.day], from: self)
        if dateComp.day == 1 {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ar_sa")
            formatter.dateFormat = "MMMM"
            return formatter.string(from: self)
        }
        return "\(dateComp.day ?? 0)"
    }

}

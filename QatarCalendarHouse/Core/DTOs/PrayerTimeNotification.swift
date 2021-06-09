//
//  PrayerTimeNotification.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/30/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation

struct PrayerTimeNotification: Hashable {
    
    //MARK: - Properties
    
    var name: String {
        return "\(type.rawValue)\(hashValue)"
    }
    let type: NotificationType
    private let date: Date
    let isIqamaEnabled: Bool
    let iqamaDifferenceTimeInMinutes: Int
    private var iqamaDate: Date? {
        guard isIqamaEnabled else { return nil }
        return date.addingTimeInterval(TimeInterval(iqamaDifferenceTimeInMinutes * 60))
    }
    
    //MARK: - Initializers
    
    internal init(type: NotificationType, date: Date, iqamaDifferenceTimeInMinutes: Int?) {
        self.type = type
        self.date = date
        self.isIqamaEnabled = iqamaDifferenceTimeInMinutes != nil
        self.iqamaDifferenceTimeInMinutes = iqamaDifferenceTimeInMinutes ?? 0
    }
    
    //MARK: - Helpers
    
    func registerningDates() -> [Date] {
        var notifications = [date]
        if let iqamaDate = iqamaDate {
            notifications.append(iqamaDate)
        }
        return notifications
    }
}

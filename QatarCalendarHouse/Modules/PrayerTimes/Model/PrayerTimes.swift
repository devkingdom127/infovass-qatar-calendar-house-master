//
//  PrayerTimes.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/28/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import Adhan

struct PrayerTimesPerDate: Codable {
    let date: Date
    let fajr : String
    let shrouk : String
    let zuhr : String
    let asr : String
    let maghrib : String
    let eshaa : String
    var day: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_eg")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

struct PrayerTimesWrapper: Codable {
    let capital: Capital
    var dates: [PrayerTimesPerDate] {
        guard let lat = Double(capital.lat), let long = Double(capital.lang) else { return [] }
        return Date.nextSevenDays().map {
            let coordinates = Coordinates(latitude: lat, longitude: long)
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let date = cal.dateComponents([.year, .month, .day], from: $0)
            let params = CalculationMethod.ummAlQura.params
            guard let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) else { return nil }
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone(abbreviation: "GMT+3")
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            return PrayerTimesPerDate(
                date: $0,
                fajr: formatter.string(from: prayers.fajr),
                shrouk: formatter.string(from: prayers.sunrise),
                zuhr: formatter.string(from: prayers.dhuhr),
                asr: formatter.string(from: prayers.asr),
                maghrib: formatter.string(from: prayers.maghrib),
                eshaa: formatter.string(from: prayers.isha)
            )
        }.compactMap {
            return $0
        }.sorted {
            $0.date < $1.date
        }
    }
}

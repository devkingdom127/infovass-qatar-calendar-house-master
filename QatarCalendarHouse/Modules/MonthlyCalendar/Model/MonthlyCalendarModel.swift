//
//  MonthlyCalendarModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class MonthlyCalendarModel {
    
    //MARK: - Properties
    
    let date: Date
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var refresher: NotificationRefresher = {
        let refresher = NotificationsModel()
        return refresher
    }()
    
    private lazy var dailyCalendarRepo: DailyCalendarRepository = {
        let repo = QCHDailyCalendarRepository(remoteAPI: remoteAPI, notificationRefresher: refresher)
        return repo
    }()
    
    private var monthNameDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_eg")
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    public var nameOfYearMonths: [String] {
        self.monthNameDateFormatter.monthSymbols
    }
    
    public var currentMonth: String {
        return monthNameDateFormatter.string(from: date)
    }
    
    //MARK: - Initializers
    
    init(date: Date = Date()) {
        self.date = date
    }
    
    //MARK: - Helpers
    
    func requestMonthlyCalendar(date: Date = Date()) -> Promise<[String: [DayCalendar]]> {
        dailyCalendarRepo.getDailyCalendar().filterValues({
            let calendar = Calendar.current
            return calendar.component(.year, from: $0.date.toDate() ?? Date()) == calendar.component(.year, from: date)
        }).compactMap {
            Dictionary(grouping: $0, by: { element in
                return self.monthNameDateFormatter.string(from: element.date.toDate() ?? Date())
            })
        }
    }
}


enum CalendarType {
    case phenomena
    case prayerTimes
    case season
    
    func title(date: Date = Date()) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        format.locale = Locale(identifier: "en")
        let formattedDate = format.string(from: date)
        switch self {
        case .phenomena: return "الظواهر الفلكية خلال عام \(formattedDate)م"
        case .prayerTimes: return "التقويم الدائم لمدينة الدوحه"
        case .season: return "المواسم"
        }
    }
}

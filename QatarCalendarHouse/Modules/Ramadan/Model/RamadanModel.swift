//
//  RamadanModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class RamadanModel: Asseted {
    
    //MARK: - Properties
    
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
    
    private lazy var allContentRepo: AllContentRepository = {
        let repo = QCHAllContentRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    lazy var ramadanYear: String = {
        let calendar = Calendar.init(identifier: .islamicUmmAlQura)
        let currentHijriMonth = calendar.component(.month, from: Date())
        let currentHijriYear = calendar.component(.year, from: Date())
        return currentHijriMonth > 10 ? "\(currentHijriYear + 1)" : "\(currentHijriYear)"
    }()

    //MARK: - Initializers
        
    //MARK: - Helpers
    
    func requestRamadanCalendars() -> Promise<[DayCalendar]> {
        return dailyCalendarRepo.getDailyCalendar().filterValues {
            guard let hijriMonth = $0.hijriMonth, hijriMonth.contains("٩") else { return false }
            let calendar = Calendar(identifier: .islamicUmmAlQura)
            let currentHijriMonth = calendar.component(.month, from: Date())
            let today = Date()
            if currentHijriMonth > 10 {
                let previousYear = calendar.date(byAdding: .year, value: 1, to: today) ?? Date()
                return calendar.component(.year, from: $0.date.toDate() ?? today) == calendar.component(.year, from: previousYear)
            } else {
                return calendar.component(.year, from: $0.date.toDate() ?? today) == calendar.component(.year, from: today)
            }
        }
    }
    
    func requestRamadanCalendarCintent() -> Promise<ContentItem> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .ramadan
        }.firstValue
    }

    func getAssetURL(for path: String) -> URL {
        return remoteAPI.getAssetURL(path: path)
    }
}

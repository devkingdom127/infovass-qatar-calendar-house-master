//
//  NotificationsModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class NotificationsModel: NotificationRefresher {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var dailyCalendarRepo: DailyCalendarRepository = {
        let repo = QCHDailyCalendarRepository(remoteAPI: remoteAPI, notificationRefresher: self)
        return repo
    }()

    //MARK: - Initializers
        
    init() {
        //NotificationManager.shared.printAllPendingNotifications()
        if UserDefaults.standard.azanNotificationPreference == nil {
            UserDefaults.standard.azanNotificationPreference = NotificationType.allCases
        }
        
        if UserDefaults.standard.iqamaNotificationPreference == nil {
            UserDefaults.standard.iqamaNotificationPreference = NotificationType.allCases
            var azanIqamaNotificationPreference = [String : Int]()
            for item in NotificationType.allCases {
                azanIqamaNotificationPreference[item.rawValue] = 10
            }
            UserDefaults.standard.azanIqamaNotificationPreference = azanIqamaNotificationPreference
        }

    }
    
    //MARK: - Helpers
    
    func refresh() -> Promise<Void> {
        return firstly {
            dailyCalendarRepo.getDailyCalendar()
        }.then(on: .global(qos: .background)) {
            self.onlyNeededCalendars($0)
        }.then(on: .global(qos: .background)) {
            self.refreshNotifications($0)
        }.done(on: .main) {
            NotificationManager.shared.printAllPendingNotifications()
        }
    }
    
    func refreshNotifications(_ calendars: [DayCalendar]) -> Promise<Void> {
        let azan = Promise { seal in
            UserDefaults.standard.azanNotificationPreference?.forEach { type in
                firstly {
                    self.deactivateNotification(ofType: type)
                }.then(on: .global(qos: .background)) {
                    when(fulfilled: calendars.compactMap {
                        self.transformIntoNotificationPromise($0, for: type, isAzan: true)
                    })
                }.done(on: .main) {
                    seal.fulfill(())
                }.catch(on: .main) {
                    seal.reject($0)
                }
            }
        }
        
        let iqama = Promise<Void> { seal in
            UserDefaults.standard.iqamaNotificationPreference?.forEach { type in
                let difference = UserDefaults.standard.azanIqamaNotificationPreference[type.rawValue]
                firstly {
                    self.deactivateNotification(ofType: type, isAzan: false)
                }.then(on: .global(qos: .background)) {
                    when(fulfilled: calendars.compactMap {
                        self.transformIntoNotificationPromise($0, for: type, isAzan: false, additionMin: difference ?? 10)
                    })
                }.done(on: .main) {
                    seal.fulfill(())
                }.catch(on: .main) {
                    seal.reject($0)
                }
            }
        }
        return when(fulfilled: azan, iqama)
    }
    
    func deactivateNotification(ofType type: NotificationType, isAzan: Bool = true) -> Promise<Void> {
        NotificationManager.shared.cancelPendingNotifications(for: type, isAzan: isAzan)
    }
    
    private func onlyNeededCalendars(_ calendars: [DayCalendar]) -> Promise<[DayCalendar]> {
        return Promise { seal in
            let dates = Array(calendars.filter {
                guard let date = $0.date.toDate() else { return false }
                return $0.date == Date().stringFormatted() || date > Date()
            }.prefix(upTo: 6))
            seal.fulfill(dates)
        }
    }
        
    private func transformIntoNotificationPromise(_ calendar: DayCalendar, for type: NotificationType, isAzan: Bool, additionMin: Int? = nil) -> Promise<Void> {
        var registeredDate: Date
        switch type {
        case .fajr:
            guard let date = "\(calendar.date) \(calendar.fajr) GMT+03:00".toPrayDate() else { return Promise() }
            registeredDate = date
        case .zuhr:
            guard let date = "\(calendar.date) \(calendar.zuhr) GMT+03:00".toPrayDate() else { return Promise() }
            registeredDate = date
        case .asr:
            guard let date = "\(calendar.date) \(calendar.asr) GMT+03:00".toPrayDate() else { return Promise() }
            registeredDate = date
        case .maghrib:
            guard let date = "\(calendar.date) \(calendar.maghrib) GMT+03:00".toPrayDate() else { return Promise() }
            registeredDate = date
        case .eshaa:
            guard let date = "\(calendar.date) \(calendar.eshaa) GMT+03:00".toPrayDate() else { return Promise() }
            registeredDate = date
        }
        
        if let addition = additionMin {
            registeredDate = registeredDate.addingTimeInterval(TimeInterval(addition * 60))
        }
        let enabled = !UserDefaults.standard.azanSoundTurnOff
        return NotificationManager.shared.newNotification(for: type, at: registeredDate, isAzan: isAzan, enabled: enabled)
    }
}

protocol NotificationRefresher {
    func refresh() -> Promise<Void>
}

//
//  QCHDailyCalendarRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/13/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit
import StorageManager

extension FileManager {
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.qatar.calendar.house.contents"
        )!
    }
}

struct QCHDailyCalendarRepository: DailyCalendarRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let notificationRefresher: NotificationRefresher
    let storage: ContentStorage
        
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, notificationRefresher: NotificationRefresher, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
        self.notificationRefresher = notificationRefresher
    }
    
    //MARK: - Actions
        
    func getDailyCalendar(forceReload: Bool = false, shouldCache: Bool = true) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getDailyCalendar()
                .get {
                    if shouldCache {
                        self.storage.store($0.list ?? [], key: .years, version: $0.version.value)
                    }
            }
            .compactMap {
                $0.list
            }
        }
        return storage.getSavedContent(key: .years)
            .recover { _ in
                self.remoteAPI.getDailyCalendar()
                    .get {
                        self.storage.store($0.list ?? [], key: .years, version: $0.version.value)
                }
                .compactMap {
                    $0.list
                }
        }
    }
    
    func writeContents(contents: [DayCalendar]) {
        let widgetContents = contents.map {
            WidgetContent(dayCalendarDate: $0.date, fajr: $0.fajr, shrouk: $0.shrouk, zuhr: $0.zuhr, asr: $0.asr, maghrib: $0.maghrib, eshaa: $0.eshaa)
        }
        let archiveURL = FileManager.sharedContainerURL()
            .appendingPathComponent("contents.json")
        print(">>> \(archiveURL)")
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(widgetContents) {
            do {
                try dataToSave.write(to: archiveURL)
            } catch {
                print("Error: Can't write contents")
                return
            }
        }
    }

    func getCurrentDayCalendar(date: Date = Date(), forceReload: Bool = false, shouldCache: Bool = true) -> Promise<DayCalendar> {
        return getDailyCalendar(forceReload: forceReload, shouldCache: shouldCache).then {
            self.getCurrentDayCalendar(from: $0, date: date)
        }
    }
    
    //MARK: - Helpers
    
    private func getCurrentDayCalendar(from calendars: [DayCalendar], date: Date = Date()) -> Promise<DayCalendar> {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "dd-MM-yyyy"
        return Promise { seal in
            let filteredCalendars = calendars.filter { $0.date == formatter.string(from: date) }
            guard let currentCalendar = filteredCalendars.first else {
                seal.reject(QCHDailyCalendarRepositoryError.notFound)
                return
            }
            seal.fulfill(currentCalendar)
        }
    }
}

enum QCHDailyCalendarRepositoryError: Error, CancellableError {
    case notFound
    case cancel
}

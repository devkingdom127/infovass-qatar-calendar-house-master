//
//  HomeModel.swift
//  OffaratMasr
//
//  Created by Amr Salman on 12/23/19.
//  Copyright © 2019 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class HomeModel {
    
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
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
    func refreshNotifications() {
        _ = self.refresher.refresh()
    }
    
    func requestCalendar(date: Date = Date()) -> Promise<DayCalendar> {
        return dailyCalendarRepo.getCurrentDayCalendar(date: date, forceReload: false, shouldCache: true)
    }
}

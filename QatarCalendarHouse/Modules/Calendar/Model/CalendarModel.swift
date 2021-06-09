//
//  CalendarModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class CalendarModel {
    
    //MARK: - Properties
    var lastDayCalendarAvailablePromise: Promise<DayCalendar>?
    var lastDayCalendarAvailable: DayCalendar?

    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
        
    private lazy var vacationRepo: VacationRepository = {
        let repo = QCHVacationRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    private lazy var refresher: NotificationRefresher = {
        let refresher = NotificationsModel()
        return refresher
    }()

    private lazy var dailyCalendarRepo: DailyCalendarRepository = {
        let repo = QCHDailyCalendarRepository(remoteAPI: remoteAPI, notificationRefresher: refresher)
        return repo
    }()

    //MARK: - Initializers
    
    init() {
        lastDayCalendarAvailablePromise = dailyCalendarRepo.getDailyCalendar().lastValue
    }
    //MARK: - Helpers
    
    func requestVacations(for date: Date) -> Promise<[Vacation]> {
        vacationRepo.isThereVacation(at: date)
    }
}

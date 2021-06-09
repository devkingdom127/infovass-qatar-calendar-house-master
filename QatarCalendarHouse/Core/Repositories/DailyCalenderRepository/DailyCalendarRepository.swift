//
//  DailyCalendarRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/13/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol DailyCalendarRepository {
    func getDailyCalendar(forceReload: Bool, shouldCache: Bool) -> Promise<[DayCalendar]>
    func getCurrentDayCalendar(date: Date, forceReload: Bool, shouldCache: Bool) -> Promise<DayCalendar>
}

extension DailyCalendarRepository {
    
    func getDailyCalendar(forceReload: Bool = false, shouldCache: Bool = true) -> Promise<[DayCalendar]> {
        return getDailyCalendar(forceReload: forceReload, shouldCache: shouldCache)
    }
}

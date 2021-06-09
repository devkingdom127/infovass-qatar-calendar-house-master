//
//  PrayTimesRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol PrayTimesRepository {
    func getCapitals(forceReload: Bool) -> Promise<[Capital]>
    func getAlmadinah(forceReload: Bool) -> Promise<[DayCalendar]>
    func getRyiad(forceReload: Bool) -> Promise<[DayCalendar]>
    func getManama(forceReload: Bool) -> Promise<[DayCalendar]>
    func getMuscat(forceReload: Bool) -> Promise<[DayCalendar]>
    func getMakkah(forceReload: Bool) -> Promise<[DayCalendar]>
    func getKuwait(forceReload: Bool) -> Promise<[DayCalendar]>
    func getAbudhabi(forceReload: Bool) -> Promise<[DayCalendar]>
}

extension PrayTimesRepository {
    
    func getCapitals(forceReload: Bool = false) -> Promise<[Capital]> {
        return getCapitals(forceReload: forceReload)
    }
    func getAlmadinah(forceReload: Bool = false) -> Promise<[DayCalendar]> {
        return getAlmadinah(forceReload: forceReload)
    }
    func getRyiad(forceReload: Bool = false) -> Promise<[DayCalendar]> {
        return getRyiad(forceReload: forceReload)
    }
    func getManama(forceReload: Bool = false) -> Promise<[DayCalendar]> {
        return getManama(forceReload: forceReload)
    }
    func getMuscat(forceReload: Bool = false) -> Promise<[DayCalendar]> {
        return getMuscat(forceReload: forceReload)
    }
    func getMakkah(forceReload: Bool = false) -> Promise<[DayCalendar]> {
       return getMakkah(forceReload: forceReload)
    }
    func getKuwait(forceReload: Bool = false) -> Promise<[DayCalendar]> {
        return getKuwait(forceReload: forceReload)
    }
    func getAbudhabi(forceReload: Bool = false) -> Promise<[DayCalendar]> {
        return getAbudhabi(forceReload: forceReload)
    }
}

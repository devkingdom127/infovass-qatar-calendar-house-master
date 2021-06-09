//
//  DailyCalendarAPI.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol QCHRemoteAPI: RemoteAPI {
    func getDailyCalendar() -> Promise<Response<DayCalendar>>
    func isThereVacation(at date: Date) -> Promise<Response<Vacation>>
    func getVacations() -> Promise<Response<Vacation>>
    func getSettings() -> Promise<Response<Setting>>
    func getAllContent() -> Promise<Response<ContentItem>>
    func getCapitals() -> Promise<Response<Capital>>
    func getVersion() -> Promise<Response<Version>>
    func getTalas() -> Promise<Response<Tala>>
    func getBorgs() -> Promise<Response<Borg>>
    func getAstronomies() -> Promise<Response<Astronomy>>
    func getAlmadinah() -> Promise<Response<DayCalendar>>
    func getRyiad() -> Promise<Response<DayCalendar>>
    func getManama() -> Promise<Response<DayCalendar>>
    func getMuscat() -> Promise<Response<DayCalendar>>
    func getMakkah() -> Promise<Response<DayCalendar>>
    func getKuwait() -> Promise<Response<DayCalendar>>
    func getAbudhabi() -> Promise<Response<DayCalendar>>
    func getAllVersions() -> Promise<Response<TableVersion>>
    func getAssetURL(path: String) -> URL
    func getAlarms() -> Promise<Response<Alarm>>
}

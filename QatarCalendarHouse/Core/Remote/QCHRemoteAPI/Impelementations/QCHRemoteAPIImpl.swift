//
//  QCHRemoteAPIImpl.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class QCHRemoteAPIImpl: QCHRemoteAPI {

    //MARK: - Properties
        
    //MARK: - Initializers
        
    //MARK: - Actions
    
    func getDailyCalendar() -> Promise<Response<DayCalendar>> {
        return request(QCH.year)
    }
        
    func isThereVacation(at date: Date) -> Promise<Response<Vacation>> {
        return request(QCH.isThereVacation(date))
    }
    
    func getCapitals() -> Promise<Response<Capital>> {
        return request(QCH.capitals)
    }
    
    func getAllContent() -> Promise<Response<ContentItem>> {
        return request(QCH.allContent)
    }
    
    func getVacations() -> Promise<Response<Vacation>> {
        return request(QCH.vacations)
    }
    
    func getSettings() -> Promise<Response<Setting>> {
        return request(QCH.settings)
    }
    
    func getVersion() -> Promise<Response<Version>> {
        return request(QCH.version)
    }
        
    func getTalas() -> Promise<Response<Tala>> {
        return request(QCH.talas)
    }
    
    func getBorgs() -> Promise<Response<Borg>> {
        return request(QCH.borgs)
    }

    func getAstronomies() -> Promise<Response<Astronomy>> {
        return request(QCH.astronomies)
    }
    
    func getAlmadinah() -> Promise<Response<DayCalendar>> {
        return request(QCH.madinah)
    }
    
    func getRyiad() -> Promise<Response<DayCalendar>> {
        return request(QCH.ryiad)
    }
    
    func getManama() -> Promise<Response<DayCalendar>> {
        return request(QCH.manama)
    }
    
    func getMuscat() -> Promise<Response<DayCalendar>> {
        return request(QCH.muscat)
    }
    
    func getMakkah() -> Promise<Response<DayCalendar>> {
        return request(QCH.makkah)
    }
    
    func getKuwait() -> Promise<Response<DayCalendar>> {
        return request(QCH.kuwait)
    }
    
    func getAbudhabi() -> Promise<Response<DayCalendar>> {
        return request(QCH.abudhabi)
    }
    
    func getAllVersions() -> Promise<Response<TableVersion>> {
        return request(QCH.allVersions)
    }
    
    func getAssetURL(path: String) -> URL {
        return fullURL(from: QCH.asset, path: path)
    }
    
    func getAlarms() -> Promise<Response<Alarm>> {
        return request(QCH.alarms)
    }
}

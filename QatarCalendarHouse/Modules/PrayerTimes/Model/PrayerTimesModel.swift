//
//  PrayerTimesModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/28/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

enum CapitalType: String, CaseIterable {
    case makkah = "مكة"
    case madinah = "المدينة"
    case doha = "الدوحة"
    case abudhabi = "أبوظبي"
    case ryiad = "الرياض"
    case kuwait = "الكويت"
    case muscat = "مسقط"
    case manama = "المنامة"
}

class PrayerTimesModel {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var capitalsRepo: PrayTimesRepository = {
        let repo = QCHPrayTimesRepository(remoteAPI: remoteAPI)
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
        
    //MARK: - Helpers
    
    func requestAllCapitalsPrayerTimes() -> Promise<[PrayerTimesWrapper]> {
        return capitalsRepo.getCapitals().compactMap {  return $0.compactMap { PrayerTimesWrapper(capital: $0) } }
    }
    
    func requestPrayerTimes(for capital: CapitalType) -> Promise<[DayCalendar]> {
        switch capital {
        case .abudhabi: return capitalsRepo.getAbudhabi().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .doha: return dailyCalendarRepo.getDailyCalendar().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .madinah: return capitalsRepo.getAlmadinah().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .ryiad: return capitalsRepo.getRyiad().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .manama: return capitalsRepo.getManama().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .muscat: return capitalsRepo.getMuscat().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .makkah: return capitalsRepo.getMakkah().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        case .kuwait: return capitalsRepo.getKuwait().filterValues {
            return Date.nextSevenDays().map { $0.stringFormatted() }.contains($0.date)
        }
        }
    }

}

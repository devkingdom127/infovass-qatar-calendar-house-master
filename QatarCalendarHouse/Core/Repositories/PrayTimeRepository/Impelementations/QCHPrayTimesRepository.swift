//
//  QCHPrayTimesRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

struct QCHPrayTimesRepository: PrayTimesRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let storage: ContentStorage
    
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
    }

    //MARK: - Actions
    
    func getCapitals(forceReload: Bool) -> Promise<[Capital]> {
        if forceReload {
            return remoteAPI.getCapitals()
                .get { self.storage.store($0.list ?? [], key: .capitals, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .capitals)
            .recover { _ in
                self.remoteAPI.getCapitals()
                    .get { self.storage.store($0.list ?? [], key: .capitals, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    
    func getAlmadinah(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getAlmadinah()
                .get { self.storage.store($0.list ?? [], key: .almadinah, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .almadinah)
            .recover { _ in
                self.remoteAPI.getAlmadinah()
                    .get { self.storage.store($0.list ?? [], key: .almadinah, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    
    func getRyiad(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getRyiad()
                .get { self.storage.store($0.list ?? [], key: .ryaid, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .ryaid)
            .recover { _ in
                self.remoteAPI.getRyiad()
                    .get { self.storage.store($0.list ?? [], key: .ryaid, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    
    func getManama(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getManama()
                .get {
                    self.storage.store($0.list ?? [], key: .manama, version: $0.version.value)
            }
                .compactMap {
                    $0.list
            }
        }
        return storage.getSavedContent(key: .manama)
            .recover { _ in
                self.remoteAPI.getManama()
                    .get {
                        self.storage.store($0.list ?? [], key: .manama, version: $0.version.value)
                }
                    .compactMap {
                        $0.list
                }
        }
    }
    
    func getMuscat(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getMuscat()
                .get { self.storage.store($0.list ?? [], key: .muscat, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .muscat)
            .recover { _ in
                self.remoteAPI.getMuscat()
                    .get { self.storage.store($0.list ?? [], key: .muscat, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    
    func getMakkah(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getMakkah()
                .get {
                    self.storage.store($0.list ?? [], key: .makkah, version: $0.version.value)
            }
                .compactMap {
                    $0.list
            }
        }
        return storage.getSavedContent(key: .makkah)
            .recover { _ in
                self.remoteAPI.getMakkah()
                    .get {
                        self.storage.store($0.list ?? [], key: .makkah, version: $0.version.value)
                }
                    .compactMap {
                        $0.list
                }
        }
    }
    
    func getKuwait(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getKuwait()
                .get { self.storage.store($0.list ?? [], key: .kuwait, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .kuwait)
            .recover { _ in
                self.remoteAPI.getKuwait()
                    .get { self.storage.store($0.list ?? [], key: .kuwait, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    
    func getAbudhabi(forceReload: Bool) -> Promise<[DayCalendar]> {
        if forceReload {
            return remoteAPI.getAbudhabi()
                .get { self.storage.store($0.list ?? [], key: .abudhabi, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .abudhabi)
            .recover { _ in
                self.remoteAPI.getAbudhabi()
                    .get { self.storage.store($0.list ?? [], key: .abudhabi, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    

}

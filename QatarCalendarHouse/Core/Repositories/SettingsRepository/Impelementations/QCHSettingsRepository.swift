//
//  QCHSettingsRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit
import StorageManager

struct QCHSettingsRepository: SettingsRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let storage: ContentStorage
    
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
    }

    //MARK: - Actions
    
    func getSettings(forceReload: Bool) -> Promise<[Setting]> {
        if forceReload {
            return self.remoteAPI.getSettings()
                .get { self.storage.store($0.list ?? [], key: .settings, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .settings)
            .recover { _ in
                self.remoteAPI.getSettings()
                    .get { self.storage.store($0.list ?? [], key: .settings, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
}

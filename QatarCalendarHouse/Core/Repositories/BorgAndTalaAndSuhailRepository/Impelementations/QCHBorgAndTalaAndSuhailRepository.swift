//
//  QCHBorgAndTalaAndSuhailRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import StorageManager
import PromiseKit

struct QCHBorgAndTalaAndSuhailRepository: BorgAndTalaAndSuhailRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let storage: ContentStorage
    
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
    }
    
    //MARK: - Actions
    
    func getBorgs(forceReload: Bool) -> Promise<[Borg]> {
        if forceReload {
            return self.remoteAPI.getBorgs().get {
                self.storage.store($0.list ?? [], key: .borg, version: $0.version.value)
                self.storage.store($0.list ?? [], key: .borgTaleas, version: $0.version.value)
            }.compactMap { $0.list }
        }
        return storage.getSavedContent(key: .borg).recover { _ in
            self.remoteAPI.getBorgs().get {
                self.storage.store($0.list ?? [], key: .borg, version: $0.version.value)
                self.storage.store($0.list ?? [], key: .borgTaleas, version: $0.version.value)
            }.compactMap { $0.list }
        }
    }
    
    func getTalas(forceReload: Bool) -> Promise<[Tala]> {
        if forceReload {
            return self.remoteAPI.getTalas().get {
                self.storage.store($0.list ?? [], key: .tala, version: $0.version.value)
                self.storage.store($0.list ?? [], key: .borgTaleas, version: $0.version.value)
            }.compactMap { $0.list }
        }
        return storage.getSavedContent(key: .tala).recover { _ in
            self.remoteAPI.getTalas().get {
                self.storage.store($0.list ?? [], key: .tala, version: $0.version.value)
                self.storage.store($0.list ?? [], key: .borgTaleas, version: $0.version.value)
            }.compactMap { $0.list }
        }
    }
}

//
//  QCHAstronomiesRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

struct QCHAstronomiesRepository: AstronomiesRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let storage: ContentStorage
    
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
    }
    
    //MARK: - Actions

    func getAstronomies(forceReload: Bool) -> Promise<[Astronomy]> {
        if forceReload {
            return self.remoteAPI.getAstronomies()
                .get { self.storage.store($0.list ?? [], key: .astronomies, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .astronomies)
            .recover { _ in
                self.remoteAPI.getAstronomies()
                    .get { self.storage.store($0.list ?? [], key: .astronomies, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
}

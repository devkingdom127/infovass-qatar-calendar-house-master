//
//  QCHAllContentRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit
import StorageManager

struct QCHAllContentRepository: AllContentRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let storage: ContentStorage
    
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
    }
    
    //MARK: - Actions
    
    func getAllContent(forceReload: Bool) -> Promise<[ContentItem]> {
        if forceReload {
            return self.remoteAPI.getAllContent()
                .get { self.storage.store($0.list ?? [], key: .contents, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .contents)
            .recover { _ in
                self.remoteAPI.getAllContent()
                    .get { self.storage.store($0.list ?? [], key: .contents, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
}

//
//  QCHVacationRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

struct QCHVacationRepository: VacationRepository {
    
    //MARK: - Properties
    
    let remoteAPI: QCHRemoteAPI
    let storage: ContentStorage
    
    //MARK: - Initializers
    
    init(remoteAPI: QCHRemoteAPI, storage: ContentStorage = QCHContentStorage()) {
        self.remoteAPI = remoteAPI
        self.storage = storage
    }

    //MARK: - Actions
    
    func getVacations(forceReload: Bool) -> Promise<[Vacation]> {
        if forceReload {
            return remoteAPI.getVacations()
                .get { self.storage.store($0.list ?? [], key: .vacations, version: $0.version.value) }
                .compactMap { $0.list }
        }
        return storage.getSavedContent(key: .vacations)
            .recover { _ in
                self.remoteAPI.getVacations()
                    .get { self.storage.store($0.list ?? [], key: .vacations, version: $0.version.value) }
                    .compactMap { $0.list }
        }
    }
    
    func isThereVacation(at date: Date) -> Promise<[Vacation]> {
        return remoteAPI.isThereVacation(at: date).compactMap { $0.list }
    }
}

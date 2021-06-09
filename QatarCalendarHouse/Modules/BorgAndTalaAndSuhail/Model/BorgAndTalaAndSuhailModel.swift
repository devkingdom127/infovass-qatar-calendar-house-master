//
//  BorgAndTalaAndSuhailModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class BorgAndTalaAndSuhailModel {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var borgAndTalaAndSuhailRepo: BorgAndTalaAndSuhailRepository = {
        let repo = QCHBorgAndTalaAndSuhailRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    private lazy var allContentRepo: AllContentRepository = {
        let repo = QCHAllContentRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    //MARK: - Initializers
        
    //MARK: - Helpers
    
    func requestTalas() -> Promise<[Tala]> {
        return borgAndTalaAndSuhailRepo.getTalas()
    }
    
    func requestBorgs() -> Promise<[Borg]> {
        return borgAndTalaAndSuhailRepo.getBorgs()
    }
    
    func requestSuhailContent() -> Promise<ContentItem> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .suhail
        }.firstValue
    }
    
    func requestTalaNote() -> Promise<ContentItem> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .talasNote
        }.firstValue
    }
    
    func requestBorgNote() -> Promise<ContentItem> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .borgsNote
        }.firstValue
    }

}

//
//  AstrologicalDetailsModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class AstrologicalDetailsModel {
    
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
    
    private let type: AstrologicalType
    private let astrological: Astrological?
    
    //MARK: - Initializers
    
    init(type: AstrologicalType) {
        self.type = type
        self.astrological = nil
    }
    
    init(astrological: Astrological) {
        self.astrological = astrological
        self.type = .suhail
    }
        
    //MARK: - Helpers
    
    private func requestTala(name: String) -> Promise<Tala> {
        return borgAndTalaAndSuhailRepo
            .getTalas()
            .filterValues { $0.name.lowercased().contains(name) }
            .firstValue
    }
    
    private func requestBorg(name: String) -> Promise<Borg> {
        return borgAndTalaAndSuhailRepo
            .getBorgs()
            .filterValues { $0.name.lowercased().contains(name) }
            .firstValue
    }
    
    private func requestSuhailContent() -> Promise<ContentItem> {
        return allContentRepo.getAllContent()
            .filterValues {
                guard let type = $0.type else { return false }
                return type == .suhail
            }
            .firstValue
    }
    
    func requestContent() -> Promise<(title: String, description: String)> {
        if let astrological = astrological {
            return Promise { seal in
                seal.fulfill((astrological.name, astrological.description ?? ""))
            }
        }
        switch type {
        case .borg(let name):
            return requestBorg(name: name).map { ($0.name, $0.description ?? "") }
        case .tala(let name):
            return requestTala(name: name).map { ($0.name, $0.description ?? "") }
        case .suhail:
            return requestSuhailContent().map { ($0.title, $0.description ?? "") }
        }
    }
}

enum AstrologicalType {
    case borg(name: String), tala(name: String), suhail
}

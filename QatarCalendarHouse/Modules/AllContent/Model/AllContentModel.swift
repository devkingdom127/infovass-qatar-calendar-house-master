//
//  AllContentModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/28/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class AllContentModel: Asseted {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var allContentRepo: AllContentRepository = {
        let repo = QCHAllContentRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    private lazy var astronomiesRepo: AstronomiesRepository = {
        let repo = QCHAstronomiesRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    //MARK: - Initializers
        
    //MARK: - Helpers
    
    func requestAllContent() -> Promise<[ContentItem]> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .gregorianCalendar || type == .hijriCalendar
        }
    }
    
    func requestAstronomies() -> Promise<[Astronomy]> {
        return astronomiesRepo.getAstronomies()
    }
    
    func getAssetURL(for path: String) -> URL {
        return remoteAPI.getAssetURL(path: path)
    }

}

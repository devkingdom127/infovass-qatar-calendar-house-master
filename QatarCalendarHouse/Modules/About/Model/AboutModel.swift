//
//  AboutModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/2/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class AboutModel: Asseted {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var allContentRepo: AllContentRepository = {
        let repo = QCHAllContentRepository(remoteAPI: remoteAPI)
        return repo
    }()

    //MARK: - Initializers
    
    //MARK: - Helpers
    
    func requestAllContent() -> Promise<ContentItem> {
        return allContentRepo.getAllContent().filterValues {
            guard let type = $0.type else { return false }
            return type == .aboutUs
        }.firstValue
    }
    
    func getAssetURL(for path: String) -> URL {
        return remoteAPI.getAssetURL(path: path)
    }

}

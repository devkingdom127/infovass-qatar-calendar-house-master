//
//  ContactUsModel.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

class ContactUsModel {
    
    //MARK: - Properties
    
    private lazy var remoteAPI: QCHRemoteAPI = {
        let remote = QCHRemoteAPIImpl()
        return remote
    }()
    
    private lazy var settingsRepo: SettingsRepository = {
        let repo = QCHSettingsRepository(remoteAPI: remoteAPI)
        return repo
    }()
    
    
    //MARK: - Initializers
        
    //MARK: - Helpers
    
    func requestSettings() -> Promise<[String: String]> {
        return settingsRepo.getSettings().map { $0.reduce([String: String]()) { (dict, setting) -> [String: String] in
            var dict = dict
            dict[setting.key] = setting.value
            return dict
            }
        }
    }
}

//
//  SettingsRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol SettingsRepository {
    func getSettings(forceReload: Bool) -> Promise<[Setting]>
}

extension SettingsRepository {
    
    func getSettings(forceReload: Bool = false) -> Promise<[Setting]> {
        return getSettings(forceReload: forceReload)
    }
}

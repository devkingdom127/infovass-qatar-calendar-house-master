//
//  AstronomiesRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/3/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol AstronomiesRepository {
    func getAstronomies(forceReload: Bool) -> Promise<[Astronomy]>
}

extension AstronomiesRepository {
    
    func getAstronomies(forceReload: Bool = false) -> Promise<[Astronomy]> {
        return getAstronomies(forceReload: forceReload)
    }
}

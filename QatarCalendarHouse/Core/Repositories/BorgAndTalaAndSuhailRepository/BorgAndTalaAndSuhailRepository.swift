//
//  BorgAndTalaAndSuhailRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/29/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol BorgAndTalaAndSuhailRepository {
    func getBorgs(forceReload: Bool) -> Promise<[Borg]>
    func getTalas(forceReload: Bool) -> Promise<[Tala]>
}

extension BorgAndTalaAndSuhailRepository {
    
    func getBorgs(forceReload: Bool = false) -> Promise<[Borg]> {
        return getBorgs(forceReload: forceReload)
    }
    
    func getTalas(forceReload: Bool = false) -> Promise<[Tala]> {
        return getTalas(forceReload: forceReload)
    }
}

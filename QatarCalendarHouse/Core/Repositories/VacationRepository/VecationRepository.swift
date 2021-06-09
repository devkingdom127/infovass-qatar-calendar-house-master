//
//  VacationRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol VacationRepository {
    func getVacations(forceReload: Bool) -> Promise<[Vacation]>
    func isThereVacation(at date: Date) -> Promise<[Vacation]>
}

extension VacationRepository {
    
    func getVacations(forceReload: Bool = false) -> Promise<[Vacation]> {
        return getVacations(forceReload: forceReload)
    }
}

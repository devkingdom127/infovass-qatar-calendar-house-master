//
//  ContentStorage.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/12/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol ContentStorage {
    func getSavedContent<T: Codable>(key: Table) -> Promise<[T]>
    func store<T: Codable>(_ content: [T], key: Table, version: String)
}

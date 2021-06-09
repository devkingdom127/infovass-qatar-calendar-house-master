//
//  QCHContentStorage.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 4/12/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit
import StorageManager

class QCHContentStorage: ContentStorage {
    static func clearAllContent() {
        for key in String.Key.allCases {
            try? StorageManager.default.clear(key.rawValue)
        }
    }
    
    func getSavedContent<T>(key: Table) -> Promise<[T]> where T : Decodable, T : Encodable {
        return Promise { seal in
            do {
                let content = try StorageManager.default.arrayValue(in: key.rawValue)
                    .map {
                        $0.json
                }
                .filter {
                    $0 != "Not a valid JSON"
                }
                .compactMap {
                    $0.data(using: .utf8)
                }
                .map {
                    try JSONDecoder().decode(T.self, from: $0)
                }
                seal.fulfill(content)
            } catch {
                seal.reject(error)
            }
        }
    }
    
    func store<T>(_ content: [T], key: Table, version: String) where T : Decodable, T : Encodable {
        do {
            let jsonData = try JSONEncoder().encode(content)
            try StorageManager.default.store(data: jsonData, type: .array, in: key.rawValue)
            UserDefaults.standard.offlineTablesVersion[key.rawValue] = version
        } catch {
            //print(error.localizedDescription)
        }
    }
}

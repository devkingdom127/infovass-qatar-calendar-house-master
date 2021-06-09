//
//  AllContentRepository.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit

protocol AllContentRepository {
    func getAllContent(forceReload: Bool) -> Promise<[ContentItem]>
}

extension AllContentRepository {
    
    func getAllContent(forceReload: Bool = false) -> Promise<[ContentItem]> {
        return getAllContent(forceReload: forceReload)
    }
}

//
//  MoyaCacheable.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/4/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import Moya

protocol MoyaCacheable {
  typealias MoyaCacheablePolicy = URLRequest.CachePolicy
  var cachePolicy: MoyaCacheablePolicy { get }
}

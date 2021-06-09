//
//  ItunesAPI.swift
//  RateMyAppKit
//
//  Created by Amr Salman on 12/7/19.
//  Copyright © 2019 Amr Salman. All rights reserved.
//

import Moya

public enum ItunesAPI {
    case search(term: String)
}

extension ItunesAPI: TargetType {
    public var baseURL: URL { return URL(string: "https://itunes.apple.com")! }
    public var path: String { return "/search" }
    public var method: Moya.Method { return .get }
    public var sampleData: Data { return Data() }
    public var task: Task {
        if case let .search(term) = self {
            return .requestParameters(parameters: ["term": term, "entity": "software"],
                                      encoding: URLEncoding.default)
        } else {
            return .requestPlain
        }
    }
    public var headers: [String: String]? { return nil }
}

extension ItunesAPI: MoyaCacheable {
    public var cachePolicy: Self.MoyaCacheablePolicy {
        return .returnCacheDataElseLoad
    }
}

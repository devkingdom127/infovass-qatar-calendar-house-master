//
//  RemoteAPI.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/16/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import Foundation
import PromiseKit
import Moya

protocol RemoteAPI {
    func request<T: TargetType & MoyaCacheable, R: Codable>(_ target: T) -> Promise<Response<R>>
    func fullURL<T: TargetType>(from target: T, path: String) -> URL
}

extension RemoteAPI {
    var provider: MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(), MoyaCacheablePlugin()])
    }
    
    func request<T: TargetType & MoyaCacheable, R: Codable>(_ target: T) -> Promise<Response<R>> {
        return Promise<Response<R>> { seal in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let moyaResponse):
                    do {
                        var filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try filteredResponse.map(Response<R>.self, using: decoder)
                        seal.fulfill(response)
                    } catch {
                        seal.reject(error)
                        //print(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                    //print(error)
                }
            }
        }
    }
    
    func fullURL<T: TargetType>(from target: T, path: String) -> URL {
        return target.baseURL.deletingLastPathComponent().appendingPathComponent(path)
    }

}

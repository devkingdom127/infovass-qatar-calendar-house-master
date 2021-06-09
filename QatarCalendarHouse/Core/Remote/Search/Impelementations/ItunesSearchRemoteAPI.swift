//
//  ItunesSearchRemoteAPI.swift
//  RateMyAppKit
//
//  Created by Amr Salman on 3/19/20.
//  Copyright © 2020 Amr Salman. All rights reserved.
//

import PromiseKit
import Moya

public class ItunesSearchRemoteAPI: SearchRemoteAPI {
    
    public init() {
        
    }
        
    public func search(term: String) -> Promise<Response<App>> {
        return request(ItunesAPI.search(term: term)).then { self.validate($0) }
    }
}

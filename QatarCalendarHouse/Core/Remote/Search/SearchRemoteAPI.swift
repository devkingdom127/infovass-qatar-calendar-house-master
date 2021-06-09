//
//  SearchRemoteAPI.swift
//  RateMyAppKit
//
//  Created by Amr Salman on 3/19/20.
//  Copyright © 2020 Amr Salman. All rights reserved.
//

import PromiseKit

public protocol SearchRemoteAPI: RemoteAPI {
    func search(term: String) -> Promise<Response<App>>
}

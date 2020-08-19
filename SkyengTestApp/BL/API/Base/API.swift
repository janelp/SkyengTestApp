//
//  API.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

struct APIParams {
    var endPoint: String
    var parameters: [String: Any]?
    var completion: RequestCompletionBlock?
}

protocol API {
    func get(_ params: APIParams)
}

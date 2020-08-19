//
//  CompletionResult.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

class CompletionResult {
    var object: AnyObject?
    var error: SessionError?
    var data: Data?
    var headers: [AnyHashable: Any]?

    init(object: AnyObject?, error: SessionError?, data: Data?, headers: [AnyHashable: Any]?) {
        self.object = object
        self.error = error
        self.data = data
        self.headers = headers
    }

    func decode<T: Decodable>() -> T? {
        let apiJSONDecoder = JSONDecoder()
        guard let data = data else { return nil }
        do {
            let result = try apiJSONDecoder.decode(T.self, from: data)
            return result
        } catch {
            log.error(error)
        }
        return nil
    }
}

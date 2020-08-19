//
//  SearchManager.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

let pageSize = 20

class SearchManager {
    struct Endpoints {
        static let routes = "/words/search"
    }
    struct RequestParams: Encodable {
        var search: String
        var page: Int?
        var pageSize: Int?
    }    
    
    func search(by searchString: String,
                offset: Int,
                limit: Int = pageSize,
                api: API = SessionManager.shared,
                success: (([WordResponse]) -> Void)?,
                failure: ((SessionError) -> Void)?) {
        
        let loginRequestParameters = RequestParams(search: searchString, page: offset/pageSize, pageSize: pageSize)
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(loginRequestParameters) else {
            failure?(SessionError.noConnection)
            log.debug("Error: Encoding error")
            return
        }
        
        let encodedParameters = (try? JSONSerialization.jsonObject(with: encodedData, options: .allowFragments)).flatMap { $0 as? [String: Any] } 
        
        let requestParams = APIParams(endPoint: Endpoints.routes, parameters: encodedParameters)
        { (result) in
            if let error = result?.error {
                failure?(error)
            }
            else {
                log.verbose("\(String(describing: result?.object))")
                if let words: [WordResponse] = result?.decode() {
                    success?(words)
                }
                else {
                    let errorMessage = "\(#file), \(#function), \(#line) \(couldNotDecode)"
                    failure?(SessionError.with(code: .code400,
                                               backendErrorMessage: errorMessage))
                }
            }
        }
        api.get(requestParams)
    }
}

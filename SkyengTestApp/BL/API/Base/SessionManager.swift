//
//  SessionManager.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Alamofire

typealias RequestCompletionBlock = (CompletionResult?) -> Void

let couldNotDecode = "Could not Decode"

class SessionManager: API {
    static let shared = SessionManager(manager: Alamofire.Session())
        
    init(manager: Alamofire.Session) {
        self.manager = manager
    }
    
    private let manager: Alamofire.Session
    private let baseUrl = "https://dictionary.skyeng.ru/api/public/v1"
    private let repeatCount = 3
    private let headers = ["Content-Type": "application/json"]
    
    func post(_ params: APIParams) {
        self.request(params.endPoint, parameters: params.parameters, method: .post, completion: params.completion)
    }
    
    func put(_ params: APIParams) {
        self.request(params.endPoint, parameters: params.parameters, method: .put, completion: params.completion)
    }
    
    func delete(_ params: APIParams) {
        self.request(params.endPoint, parameters: params.parameters, method: .delete, completion: params.completion)
    }
    
    func get(_ params: APIParams) {
        self.request(params.endPoint, parameters: params.parameters, method: .get, completion: params.completion)
    }
    
    private func request(_ endPoint: String,
                         parameters: [String: Any]?,
                         method: HTTPMethod,
                         completion: RequestCompletionBlock?,
                         repeatCount: Int? = nil) {
        
        let requestInfo = RequestInfo(endPoint: endPoint,
                                      completion: completion,
                                      repeatCount: repeatCount ?? self.repeatCount,
                                      url: baseUrl + endPoint,
                                      parameters: parameters,
                                      method: method)
        manager.request(requestInfo.url,
                   method: method,
                   parameters: parameters,
                   encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                   headers: HTTPHeaders(headers)).responseJSON { (response) in
                    log.verbose(response.result)
                    self.processResult(requestInfo: requestInfo, response: response)
        }
    }
    
    struct RequestInfo {
        let endPoint: String
        let completion: RequestCompletionBlock?
        let repeatCount: Int
        let url: String
        let parameters: [String: Any]?
        let method: HTTPMethod
    }
    
    private func getBackendErrorMessage(from value: Any?) -> String {
        let json = value as? [String: Any]
        let message = json?["message"] as? String
        return message ?? "no message"
    }
    
    func handleError(error: SessionError,
                     requestInfo: RequestInfo,
                     xTraceId: String? = nil,
                     request: (_ endPoint: String,
        _ parameters: [String: Any]?,
        _ method: HTTPMethod,
        _ completion: RequestCompletionBlock?,
        _ repeatCount: Int?) -> Void) {
        
        if error == .noConnection && requestInfo.repeatCount > 0 {
            request(requestInfo.endPoint,
                    requestInfo.parameters,
                    requestInfo.method,
                    requestInfo.completion,
                    requestInfo.repeatCount - 1)
        } else {
            requestInfo.completion?(CompletionResult(object: nil,
                                                     error: error,
                                                     data: nil,
                                                     headers: nil))
        }
    }
    
    func processResult(requestInfo: RequestInfo,
                       response: AFDataResponse<Any>) {
        
        switch response.result {
        case let .success(value):
            guard let statusCode = response.response?.statusCode else {
                let serverError = SessionError.otherError(reason: "\(#file) \(#function) \(#line) - Status code = nil")
                self.handleError(error: serverError,
                                 requestInfo: requestInfo,
                                 request: self.request)
                return
            }
            
            log.verbose(requestInfo.url + " " + String(statusCode))
            
            if statusCode == 200 {
                requestInfo.completion?(
                    CompletionResult(
                        object: value as AnyObject,
                        error: nil,
                        data: response.data,
                        headers: response.response?.allHeaderFields))
            }
            else {
                // ошибка с бэка
                log.verbose("\(String(describing: response.value))")
                let backendErrorMessage = getBackendErrorMessage(from: value)
                requestInfo.completion?(
                    CompletionResult(
                        object: value as AnyObject,
                        error: SessionError(statusCode: statusCode,
                                            backendErrorMessage: backendErrorMessage),
                        data: response.data,
                        headers: response.response?.allHeaderFields))
            }
        case let .failure(error):
            switch error {
            case .sessionTaskFailed(let sessionError):
                if let err = sessionError as? URLError, err.code == URLError.Code.notConnectedToInternet {
                    let serverError = SessionError.noConnection
                    self.handleError(error: serverError,
                                     requestInfo: requestInfo,
                                     request: self.request)
                }
                else {
                    let serverError = SessionError.otherError(reason: "\(#file) \(#function) \(#line) - no message -  \(error.localizedDescription)")
                    self.handleError(error: serverError,
                                     requestInfo: requestInfo,
                                     request: self.request)
                }
            default:
                let serverError = SessionError.otherError(reason: "\(#file) \(#function) \(#line) - no message -  \(error.localizedDescription)")
                self.handleError(error: serverError,
                                 requestInfo: requestInfo,
                                 request: self.request)
            }
            return
        }
    }
}


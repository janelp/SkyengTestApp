//
//  MockURLProtocol.swift
//  SkyengTestAppTests
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation
import Alamofire
@testable import SkyengTestApp

class MockURLProtocol: URLProtocol {

    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
    }
    class var responseType: ResponseType? {
        return nil
    }

    class var data: Data? {
        return nil
    }

    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    private(set) var activeTask: URLSessionTask?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    override func startLoading() {
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }

    override func stopLoading() {
        activeTask?.cancel()
    }
}

// MARK: - URLSessionDataDelegate
extension MockURLProtocol: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch Self.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = Self.data {
                client?.urlProtocol(self, didLoad: data)
            }
        default:
            break
        }

        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockURLProtocol {

    static func responseWith(error: Error) -> ResponseType {
            .error(error)
    }

    static func responseWith(url: URL? = nil,
                             statusCode: Int,
                             httpVersion: String? = nil,
                             headerFields: [String: String]? = nil) -> ResponseType {

            .success(HTTPURLResponse(url: url ?? URL(string: "http://any.com")!,
                                     statusCode: statusCode,
                                     httpVersion: httpVersion,
                                     headerFields: headerFields)!)
    }
}

extension MockURLProtocol {

    static func manager() -> Alamofire.Session {

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [Self.self]

        return Alamofire.Session(configuration: configuration)
    }
}

extension MockURLProtocol {

    static var api: API {
        SessionManager(manager: manager())
    }
}

extension MockURLProtocol {

    fileprivate static func urlFor(file: String, ext: String) -> URL {

        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: file, withExtension: ext)
        return url!
    }

    static func data(file: String, ext: String = "json") -> Data? {

        let url = urlFor(file: file, ext: ext)
        if let data = try? Data(contentsOf: url) {
            return data
        } else {
            return nil
        }
    }
}

let ERROR_MESSAGE = "test message"

enum MockError: Error {
    case none
}


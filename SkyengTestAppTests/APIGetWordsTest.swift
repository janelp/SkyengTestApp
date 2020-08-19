//
//  APIGetWordsTest.swift
//  SkyengTestAppTests
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import XCTest
@testable import SkyengTestApp

class APIGetWordsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccess() {

        class MockSuccess: MockURLProtocol {
            override class var responseType: ResponseType? { MockURLProtocol.responseWith(statusCode: 200) }
            override class var data: Data? { MockURLProtocol.data(file: correctFile(#file)) }
        }
        
        let ex = expectation(description: "\(#file)-\(#function)")
        var words: [WordResponse]?
        var error: Error?
        SearchManager().search(by: "test",
                               offset: 0,
                               limit: 20,
                               api: MockSuccess.api,
                               success: { result in words = result; ex.fulfill() },
                               failure: { err in error = err; ex.fulfill() })
        _ = XCTWaiter.wait(for: [ex], timeout: 10)
        
        XCTAssert(error == nil)
        XCTAssertEqual(words?.first?.id,  517)
    }
    
    func testDecodeError() {

        class MockDecodeError: MockURLProtocol {
            override class var responseType: ResponseType? { MockURLProtocol.responseWith(statusCode: 200) }
            override class var data: Data? { MockURLProtocol.data(file: wrongDecodeFile(#file)) }
        }

        let ex = expectation(description: "\(#file)-\(#function)")
        var words: [WordResponse]?
        var error: Error?
        SearchManager().search(by: "test",
                               offset: 0,
                               limit: 20,
                               api: MockDecodeError.api,
                               success: { result in words = result; ex.fulfill() },
                               failure: { err in error = err; ex.fulfill() })
        _ = XCTWaiter.wait(for: [ex], timeout: 10)
        
        XCTAssert(words == nil)
        if let error = error as? SessionError,
            case .with(code: .code400, let backendErrorMessage) = error,
            backendErrorMessage?.contains(couldNotDecode) == true
        {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }
    
    func testGeneralError() {

        class MockGeneralError: MockURLProtocol {
            override class var responseType: ResponseType? { MockURLProtocol.responseWith(statusCode: 333) }
            override class var data: Data? { MockURLProtocol.data(file: correctFile(#file)) }
        }

        let ex = expectation(description: "\(#file)-\(#function)")
        var words: [WordResponse]?
        var error: Error?
        SearchManager().search(by: "test",
                               offset: 0,
                               limit: 20,
                               api: MockGeneralError.api,
                               success: { result in words = result; ex.fulfill() },
                               failure: { err in error = err; ex.fulfill() })
        _ = XCTWaiter.wait(for: [ex], timeout: 10)

        XCTAssert(words == nil)
        XCTAssert(error != nil)
    }

}

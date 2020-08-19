//
//  SessionError.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

enum SessionError: Equatable {

    enum StatusCode: Int {
        case code400 = 400
        case code401 = 401
        case code403 = 403
        case code404 = 404
    }

    case noConnection
    case otherError(reason: String?)
    case with(code: StatusCode, backendErrorMessage: String?)
    case internalServer(statusCode: Int, backendErrorMessage: String?)

    var backendError: String? {
        switch self {
        case .with(_, let backendErrorMessage):
            return backendErrorMessage
        case .internalServer(_, let backendErrorMessage):
            return backendErrorMessage
        default:
            return nil
        }
    }

    init(statusCode: Int, backendErrorMessage: String? = nil) {
        if let statusCode = StatusCode.init(rawValue: statusCode) {
            self = SessionError.with(code: statusCode, backendErrorMessage: backendErrorMessage)
        }
        else {
            self = SessionError.internalServer(statusCode: statusCode, backendErrorMessage: backendErrorMessage)
        }
    }

    static public func == (lhs: SessionError, rhs: SessionError) -> Bool {
        return lhs.errorCode == rhs.errorCode
    }

}

extension SessionError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .with(code: let code, _):
            return code.rawValue
        default:
            return 1045
        }
    }

    var errorUserInfo: [String: Any] {
        switch self {
        case .noConnection:
            return [NSLocalizedDescriptionKey: LS("no_internet")]
        case .with(let code, _):
            return [NSLocalizedDescriptionKey: self.errorMessageFor(code: code)]
        case .internalServer(_, _):
            return [NSLocalizedDescriptionKey: LS("errorInternal")]
        case .otherError:
            return [NSLocalizedDescriptionKey: LS("alamofireError")]
        }
    }

    private func errorMessageFor(code: StatusCode) -> String {
        var message: String!
        switch code {
        case .code400:
            message = LS("error400")
        case .code401:
            message = LS("error401")
        case .code403:
            message = LS("error403")
        case .code404:
            message = LS("error404")
        }
        return message
    }
}

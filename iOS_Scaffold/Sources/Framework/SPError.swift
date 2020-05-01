//
//  SPError.swift
//  iOS_Scaffold
//
//  Created by Shper on 2020/4/25.
//  Copyright © 2020 Shper. All rights reserved.
//

import Foundation

public enum SPError : Error {
    
    case network(String, String?)
}

public extension SPError {

    /// Depending on error type, returns a `Response` object.
    var response: String? {
        switch self {
        case .network: return nil
        }
    }

    /// Depending on error type, returns an underlying `Error`.
    internal var underlyingError: Swift.Error? {
        switch self {
        case .network: return nil
        }
    }
}

// MARK: - Error Descriptions

extension SPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network:
            return "Failed to request network."
        }
    }
}

// MARK: - Error User Info

extension SPError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
}

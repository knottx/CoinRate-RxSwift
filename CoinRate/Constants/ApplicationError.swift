//
//  ApplicationError.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

enum ApplicationError: Error {
    case error(title:String? = nil, message:String? = nil, statusCode:Int? = nil)
    case unknownError(statusCode:Int? = nil)
    case invalidJSONResponse
    case invalidLocation
    case emptyField
}

extension ApplicationError: LocalizedError {
    
    public var title:String {
        get{
            switch self {
            case .error(let title, _, _):
                return title ?? "error_title"
            default:
                return "error_title"
            }
        }
    }
    
    public var message:String {
        get {
            switch self {
            case .error(_, let message, _): return message ?? "error_title"
            case .unknownError:             return "unknown_error"
            case .invalidJSONResponse:      return "error_invalid_json"
            case .invalidLocation:          return "Invalid Location"
            case .emptyField:               return "empty field"
            }
        }
    }
    
    public var statusCode:Int? {
        get {
            switch self {
            case .error(_, _, let statusCode),
                 .unknownError(let statusCode):
                    return statusCode
            default:
                return nil
            }
        }
    }
    
}

//
//  CoinRouter.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation
import Alamofire

enum CoinRouter: Router {
    
    case assets
    case allExchangeRate(baseId:String)
    case exchangeRate(baseId:String, quoteId:String)
    
    var method: HTTPMethod {
        get{
            switch self {
            case .assets,
                 .allExchangeRate,
                 .exchangeRate:
                return .get
            }
        }
    }
    
    var path: String {
        get{
            switch self {
            case .assets:                               return "assets"
            case .allExchangeRate(let baseId):            return "exchangerate/\(baseId)"
            case .exchangeRate(let baseId, let quoteId):    return "exchangerate/\(baseId)/\(quoteId)"
            }
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .assets,
             .allExchangeRate,
             .exchangeRate:
            return try self.request(params: nil)
        }
    }
    
}


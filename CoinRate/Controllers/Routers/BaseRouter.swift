//
//  BaseRouter.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation
import Alamofire

protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    func asURLRequest() throws -> URLRequest
}

extension Router {
    func request(params: Parameters?) throws -> URLRequest {
        if let url = URL(string: "\(Constant.weatherUrl)/v1/") {
            var urlRequest = URLRequest(url: url.appendingPathComponent(self.path),
                                        cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30.0)
            urlRequest.httpMethod = self.method.rawValue
            switch self.method {
            case .get:
                urlRequest = try URLEncoding.init(destination: .queryString, arrayEncoding: .brackets, boolEncoding: .literal).encode(urlRequest, with: params)
            default:
                if let params = params {
                    urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
                }
            }
            return urlRequest
        }else{
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        }
        
    }
    
}


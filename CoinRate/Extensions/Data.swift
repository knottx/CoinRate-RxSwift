//
//  Data.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

extension Data {
    
    func jsonObject(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        return try JSONSerialization.jsonObject(with: self, options: options) as? [String: Any]
    }
    
    func jsonObjectOrEmpty(options: JSONSerialization.ReadingOptions = .allowFragments) -> [String: Any] {
        if let jObj = try? JSONSerialization.jsonObject(with: self, options: options), let dict = jObj as? [String: Any] {
            return dict
        }
        return [:]
    }
    
    func jsonArray(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [[String: Any]]? {
        return try JSONSerialization.jsonObject(with: self, options: options) as? [[String: Any]]
    }
    
    func jsonArrayOrEmpty(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [[String: Any]] {
        if let jArray = try? JSONSerialization.jsonObject(with: self, options: options),
        let array = jArray as? [[String: Any]] {
            return array
        }
        return []
    }
    
    func asString(enoding: String.Encoding = .utf8) -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
    
}

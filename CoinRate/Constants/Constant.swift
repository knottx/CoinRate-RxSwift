//
//  Constant.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

struct Constant {
    static let weatherUrl = "https://rest.coinapi.io"
    static let apiKey = "8B0B6121-E329-4E74-8F82-2EC7DEB35DE9"
}

struct Formatter {
    
    static var iso8601: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            return formatter
        }
    }
    
}

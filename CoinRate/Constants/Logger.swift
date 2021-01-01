//
//  Logger.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

enum Logger: String {
    case request
    case response
    case critical
    case other
    
    var name: String {
        return self.rawValue.capitalized
    }
    
    var symbol: String {
        switch self {
        case .request:
            return "📡"
        case .response:
            return "✏️"
        case .critical:
            return "⛔️"
        case .other:
            return "🔍"
        }
    }
    
    func message(_ value: String) -> String {
        return "\(self.symbol): [\(self.name)] => \(value)"
    }
    
    func log(_ value: String) {
        print(self.message(value))
    }
}

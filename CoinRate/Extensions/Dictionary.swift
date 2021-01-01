//
//  Dictionary.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

extension Dictionary {
    
    func data(option: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: option)
    }
    
    mutating func update(other:Dictionary) {
        other.forEach { (key, value) in
            self.updateValue(value, forKey: key)
        }
    }
    
}

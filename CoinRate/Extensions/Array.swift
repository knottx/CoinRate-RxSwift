//
//  Array.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

extension Array {
    
    func data(option: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: option)
    }
}

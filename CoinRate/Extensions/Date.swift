//
//  Date.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

extension Date {
    
    func toString(withFormat format:String = "dd-MM-yyyy HH:mm") -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
}

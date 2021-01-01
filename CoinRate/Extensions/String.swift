//
//  String.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

extension String {
    
    func toDate(withFormat format:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
}

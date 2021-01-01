//
//  ExchangeRate.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

struct ExchangeRate: Codable {
    var time:Date?
    var assetIdBase:String?
    var assetIdQuote:String?
    var rate:Double?
    
    private enum CodingKeys:String, CodingKey {
        case time
        case assetIdBase = "asset_id_base"
        case assetIdQuote = "asset_id_quote"
        case rate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let time = try? container.decodeIfPresent(String.self, forKey: .time) {
            self.time = time.toDate()
        }
        self.assetIdBase = try? container.decodeIfPresent(String.self, forKey: .assetIdBase)
        self.assetIdQuote = try? container.decodeIfPresent(String.self, forKey: .assetIdQuote)
        self.rate = try? container.decodeIfPresent(Double.self, forKey: .rate)
    }
    
    func encode(to encoder: Encoder) throws {
        var value = encoder.container(keyedBy: CodingKeys.self)
        try? value.encode(self.time, forKey: .time)
        try? value.encode(self.assetIdBase, forKey: .assetIdBase)
        try? value.encode(self.assetIdQuote, forKey: .assetIdQuote)
        try? value.encode(self.rate, forKey: .rate)
    }
    
}

struct AllExchangeRate: Codable {
    var assetIdBase:String?
    var rates:[ExchangeRate] = []
    
    private enum CodingKeys:String, CodingKey {
        case assetIdBase = "asset_id_base"
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.assetIdBase = try? container.decodeIfPresent(String.self, forKey: .assetIdBase)
        self.rates = (try? container.decodeIfPresent([ExchangeRate].self, forKey: .rates)) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var value = encoder.container(keyedBy: CodingKeys.self)
        try? value.encode(self.assetIdBase, forKey: .assetIdBase)
        try? value.encode(self.rates, forKey: .rates)
    }
    
}

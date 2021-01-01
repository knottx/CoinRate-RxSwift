//
//  CoinAsset.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation

struct CoinAsset: Codable {
    var assetId:String?
    var name:String?
    var typeIsCrypto:Int?
    
    private enum CodingKeys:String, CodingKey {
        case assetId = "asset_id"
        case name
        case typeIsCrypto = "type_is_crypto"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.assetId = try? container.decodeIfPresent(String.self, forKey: .assetId)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.typeIsCrypto = try? container.decodeIfPresent(Int.self, forKey: .typeIsCrypto)
    }
    
    func encode(to encoder: Encoder) throws {
        var value = encoder.container(keyedBy: CodingKeys.self)
        try? value.encode(self.assetId, forKey: .assetId)
        try? value.encode(self.name, forKey: .name)
        try? value.encode(self.typeIsCrypto, forKey: .typeIsCrypto)
    }
    
}

extension CoinAsset {
    
    var isCrypto:Bool {
        get{
            return self.typeIsCrypto == 1
        }
    }
    
}

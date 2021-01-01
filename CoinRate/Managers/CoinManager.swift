//
//  CoinManager.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation
import RxSwift
import RxCocoa

class CoinManager {
    
    static let shared = CoinManager()
    private let bag = DisposeBag()
    
    var allAssetList = BehaviorRelay<[CoinAsset]>(value: [])
    var cryptoAssetList = BehaviorRelay<[CoinAsset]>(value: [])
    var normalAssetList = BehaviorRelay<[CoinAsset]>(value: [])
    
    init() {
        self.allAssetList.map({$0.filter({$0.typeIsCrypto == 1})}).bind(to: self.cryptoAssetList).disposed(by: self.bag)
        self.allAssetList.map({$0.filter({$0.typeIsCrypto == 0})}).bind(to: self.cryptoAssetList).disposed(by: self.bag)
    }
    
    func getAssetList() -> Completable {
        return Completable.create { (completable) -> Disposable in
            CoinService.shared.getAssetList().subscribe { (result) in
                self.allAssetList.accept(result)
                completable(.completed)
            } onError: { (error) in
                completable(.error(error))
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
    
}

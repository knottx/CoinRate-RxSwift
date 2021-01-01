//
//  MainViewModel.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    var rateValue = BehaviorRelay<String?>(value: nil)
    var selectedBaseAsset = BehaviorRelay<CoinAsset?>(value: nil)
    
    var currentValue = BehaviorRelay<Double>(value: 1)
    var currentBaseAsset = BehaviorRelay<CoinAsset?>(value: nil)
    var allRate = BehaviorRelay<AllExchangeRate?>(value: nil)
    var dataSource = BehaviorRelay<[ExchangeRate]>(value: [])
    
    private let bag = DisposeBag()
    
    init() {
        self.allRate.map({$0?.rates ?? []}).bind(to: self.dataSource).disposed(by: self.bag)
    }
    
    func getAllRate() -> Completable {
        return Completable.create { (completable) -> Disposable in
            guard let baseId = self.selectedBaseAsset.value?.assetId else {
                completable(.error(ApplicationError.emptyField))
                return Disposables.create()
            }
            CoinService.shared.allExchangeRate(baseId: baseId).subscribe { (result) in
                self.currentValue.accept(Double(self.rateValue.value ?? "1") ?? 1)
                self.currentBaseAsset.accept(self.selectedBaseAsset.value)
                self.allRate.accept(result)
                completable(.completed)
            } onError: { (error) in
                completable(.error(error))
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
}

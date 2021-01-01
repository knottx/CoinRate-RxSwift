//
//  CoinService.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation
import RxSwift

class CoinService {
    static let shared = CoinService()
    private let bag = DisposeBag()
    
    func getAssetList() -> Observable<[CoinAsset]> {
        return Observable.create { (observable) -> Disposable in
            do{
                let request = try CoinRouter.assets.asURLRequest()
                APIController.shared.requestAndDecode(withURLRequest: request, of: [CoinAsset].self).subscribe { (result) in
                    observable.onNext(result)
                    observable.onCompleted()
                } onError: { (error) in
                    observable.onError(error)
                }.disposed(by: self.bag)
            }catch let error {
                observable.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func allExchangeRate(baseId:String) -> Observable<AllExchangeRate> {
        return Observable.create { (observable) -> Disposable in
            do{
                let request = try CoinRouter.allExchangeRate(baseId: baseId).asURLRequest()
                APIController.shared.requestAndDecode(withURLRequest: request, of: AllExchangeRate.self).subscribe { (result) in
                    observable.onNext(result)
                    observable.onCompleted()
                } onError: { (error) in
                    observable.onError(error)
                }.disposed(by: self.bag)
            }catch let error {
                observable.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func exchangeRate(baseId:String, quoteId:String) -> Observable<ExchangeRate> {
        return Observable.create { (observable) -> Disposable in
            do{
                let request = try CoinRouter.exchangeRate(baseId: baseId, quoteId: quoteId).asURLRequest()
                APIController.shared.requestAndDecode(withURLRequest: request, of: ExchangeRate.self).subscribe { (result) in
                    observable.onNext(result)
                    observable.onCompleted()
                } onError: { (error) in
                    observable.onError(error)
                }.disposed(by: self.bag)
            }catch let error {
                observable.onError(error)
            }
            return Disposables.create()
        }
    }
    
}

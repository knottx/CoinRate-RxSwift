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
            var stringUrl = Constant.coinUrl
            stringUrl.append("assets")
            APIController.shared.requestAndDecode(method: .get, requestUrl: URL(string: stringUrl)!, of: [CoinAsset].self).subscribe { (result) in
                observable.onNext(result)
                observable.onCompleted()
            } onError: { (error) in
                observable.onError(error)
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
    func allExchangeRate(baseId:String) -> Observable<AllExchangeRate> {
        return Observable.create { (observable) -> Disposable in
            var stringUrl = Constant.coinUrl
            stringUrl.append("exchangerate/\(baseId)")
            APIController.shared.requestAndDecode(method: .get, requestUrl: URL(string: stringUrl)!, of: AllExchangeRate.self).subscribe { (result) in
                observable.onNext(result)
                observable.onCompleted()
            } onError: { (error) in
                observable.onError(error)
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
    func exchangeRate(baseId:String, quoteId:String) -> Observable<ExchangeRate> {
        return Observable.create { (observable) -> Disposable in
            var stringUrl = Constant.coinUrl
            stringUrl.append("exchangerate/\(baseId)/\(quoteId)")
            APIController.shared.requestAndDecode(method: .get, requestUrl: URL(string: stringUrl)!, of: ExchangeRate.self).subscribe { (result) in
                observable.onNext(result)
                observable.onCompleted()
            } onError: { (error) in
                observable.onError(error)
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
}

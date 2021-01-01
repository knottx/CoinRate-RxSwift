//
//  APIController.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

typealias AlamofireRequestConvertible = Alamofire.URLRequestConvertible

class APIResponseMiddleware {
    
    static let shared = APIResponseMiddleware()
    
    func inject(data: DataResponse<Any, AFError>) {
        if let statusCode = data.response?.statusCode {
            Logger.response.log("Status Code: \(statusCode)")
        }
        if let response = data.data?.asString() {
            Logger.response.log(response)
        }
        if let headers = data.response?.allHeaderFields as? [String: Any] {
            Logger.response.log((try? headers.data().asString()) ?? "")
        }
    }
    
}


class APIRequestInterceptor: RequestInterceptor {
    
    static let shared = APIRequestInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.setValue(Constant.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        return completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < 3 else{
            completion(.doNotRetry)
            return
        }
        completion(.retry)
    }
}

class APIController {
    static let shared = APIController()
    static let background = APIController(background: true)
    private let bag = DisposeBag()
    let manager:Session
    
    init(background:Bool = false) {
        let configuration:URLSessionConfiguration = background ? .background(withIdentifier: "background") : .default
        configuration.httpMaximumConnectionsPerHost = 12
        configuration.timeoutIntervalForRequest = 45
        self.manager = Session(configuration: configuration, interceptor: APIRequestInterceptor.shared)
    }
    
    
    func requestAndDecode<T:Decodable>(withURLRequest URLRequest:URLRequest, of:T.Type, rootKey:String = "data") -> Observable<T> {
        return Observable.create { (observable) -> Disposable in
            self.manager.rx.request(urlRequest: URLRequest).responseJSON().subscribe { (response) in
                APIResponseMiddleware.shared.inject(data: response)
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200 ..< 300:
                        if let JSONObject = ((try? response.data?.jsonObject()) as [String : Any]??){
                            if  let dataJSON = JSONObject?[rootKey] as? [String: Any],
                                let data = try? JSONDecoder().decode(T.self, from: dataJSON.data()) {
                                observable.onNext(data)
                                observable.onCompleted()
                            }else if let JSONObject = ((try? response.data?.jsonObject()) as [String: Any]??),
                                     let dataJSON = JSONObject?[rootKey] as? [[String:Any]],
                                     let data = try? JSONDecoder().decode(T.self, from: dataJSON.data()) {
                                observable.onNext(data)
                                observable.onCompleted()
                            }else if let data = response.data,
                                     let object = try? JSONDecoder().decode(T.self, from: data) {
                                observable.onNext(object)
                                observable.onCompleted()
                            }else if let result = true as? T {
                                observable.onNext(result)
                                observable.onCompleted()
                            }else{
                                observable.onError(ApplicationError.invalidJSONResponse)
                            }
                        }else{
                            observable.onError(ApplicationError.invalidJSONResponse)
                        }
                    default:
                        if let JSONObject = ((try? response.data?.jsonObject()) as [String : Any]??) {
                            if let message = JSONObject?["message"] as? String {
                                observable.onError(ApplicationError.error(message: message, statusCode: statusCode))
                            }else{
                                observable.onError(ApplicationError.unknownError(statusCode: statusCode))
                            }
                        }else if let error = response.error {
                            observable.onError(error)
                        }else{
                            observable.onError(ApplicationError.unknownError(statusCode: statusCode))
                        }
                    }
                }else if let error = response.error {
                    observable.onError(error)
                }else{
                    observable.onError(ApplicationError.unknownError(statusCode: nil))
                }
            } onError: { (error) in
                observable.onError(error)
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
}

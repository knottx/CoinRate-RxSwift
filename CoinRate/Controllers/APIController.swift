//
//  APIController.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import Alamofire
import RxSwift
import RxAlamofire

class APIController {
    
    static let shared = APIController()
    private let bag = DisposeBag()
    
    func requestAndDecode<T:Decodable>(method: HTTPMethod, requestUrl:URL, of:T.Type) -> Observable<T> {
        return Observable.create { (observable) -> Disposable in
            var url = URLRequest(url: requestUrl)
            url.httpMethod = method.rawValue
            url.addValue(Constant.apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            AF.rx.request(urlRequest: url).responseJSON().subscribe { (response) in
                if let request = response.request {
                    Logger.request.log(request.cURL)
                }
                if let data = response.data, let dataString = String(data: data, encoding: .utf8) {
                    Logger.response.log(dataString)
                }
                if let statusCode = response.response?.statusCode {
                    Logger.response.log("Status Code: \(statusCode)")
                    switch statusCode {
                    case 200 ..< 300:
                        if let JSONObject = ((try? response.data?.jsonObject()) as [String : Any]??){
                            if  let dataJSON = JSONObject?["data"] as? [String: Any],
                                let data = try? JSONDecoder().decode(T.self, from: dataJSON.data()) {
                                observable.onNext(data)
                                observable.onCompleted()
                            }else if let JSONObject = ((try? response.data?.jsonObject()) as [String: Any]??),
                                     let dataJSON = JSONObject?["data"] as? [[String:Any]],
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
                        do{
                            if let data = response.data,
                               let JSONObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                                if let message = JSONObject["message"] as? String {
                                    observable.onError(ApplicationError.error(message: message, statusCode: statusCode))
                                }else{
                                    observable.onError(ApplicationError.unknownError(statusCode: statusCode))
                                }
                            }else if let error = response.error {
                                observable.onError(error)
                            }else{
                                observable.onError(ApplicationError.unknownError(statusCode: statusCode))
                            }
                        }catch let error {
                            observable.onError(error)
                        }
                    }
                }else if let error = response.error {
                    observable.onError(error)
                }else{
                    observable.onError(ApplicationError.unknownError(statusCode: nil))
                }
            } onError: { (error) in
                Logger.critical.log(error.localizedDescription)
                observable.onError(error)
            }.disposed(by: self.bag)
            return Disposables.create()
        }
    }
    
}

//
//  ApiManager.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import Moya
import RxSwift
import ObjectMapper

enum APIError: Error {
    case serverError
    case unknown
    case forwarded(Error)
}

class ApiManager<P: TargetType> {
    
    private let provider: MoyaProvider<P>
    
    init() {
        self.provider = MoyaProvider<P>()
    }
    
    func request<T: Mappable>(_ Type: T.Type, _ service: P) -> Observable<T> {
        return Observable.create { observer in
            self.provider.request(service) { result in
                switch result {
                case let .success(response):
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any]
                        if let data = Mapper<T>().map(JSON: json.orElse([:])) {
                            observer.onNext(data)
                        } else {
                            observer.onError(APIError.unknown)
                        }
                    } catch (let error) {
                        observer.onError(error)
                    }
                    
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

extension Error {
    func toAPIError() -> APIError {
        return (self as? APIError).orElse(APIError.forwarded(self))
    }
}

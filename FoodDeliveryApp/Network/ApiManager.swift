//
//  ApiManager.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import Moya
import RxSwift
import ObjectMapper

enum APIError: Error, CustomStringConvertible {
    case serverError
    case unknown
    case forwarded(Error)
    
    var description: String {
        switch self {
        case .serverError:
            return "Server Error!"
        case .unknown:
            return "Something went wrong!"
        case .forwarded(let error):
            return error.localizedDescription
        }
    }
}

class ApiManager<P: TargetType> {
    
    private let provider: MoyaProvider<P>
    
    init(provider: MoyaProvider<P>) {
        self.provider = provider
    }
    
    func request<T: BaseResponse>(_ Type: T.Type, _ service: P) -> Observable<T> {
        return Observable.create { observer in
            self.provider.request(service) { result in
                switch result {
                case let .success(response):
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any]
                        if let data = Mapper<T>().map(JSON: json.orElse([:])) {
                            if data.isSuccess() {
                                observer.onNext(data)
                            } else {
                                observer.onError(APIError.serverError)
                            }
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

//
//  ErrorTracker.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import RxCocoa

class ErrorTracker {
    
    private let errorSubject = PublishSubject<Error>()
    
    func track<T: ObservableConvertibleType>(source: T) -> Observable<T.E> {
        return source.asObservable().do(onError: onError)
    }
    
    func asDriver() -> Driver<Error> {
        return errorSubject
            .asDriver(onErrorDriveWith: .never())
    }
    
    func onError(error: Error) {
        errorSubject.onNext(error)
    }
}

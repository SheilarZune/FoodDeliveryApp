//
//  LoadingTracker.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import RxCocoa

class ActivityTracker {
    
    private let loadingSubject = PublishSubject<Bool>()

    func track<T: ObservableConvertibleType>(source: T) -> Observable<T.E> {
        loadingSubject.onNext(true)
        return source.asObservable().do(onNext: { _ in
            self.loadingSubject.onNext(false)
        }, onError: { _ in
            self.loadingSubject.onNext(false)
        })
    }
    
    func asDriver() -> Driver<Bool> {
        return loadingSubject
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
    }
}


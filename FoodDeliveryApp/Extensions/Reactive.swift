//
//  Reactive.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import RxCocoa
import RxSwiftExt

extension Collection where Element == Bool {
    func mapToVoid() -> Void {
        return ()
    }
}

extension ObservableConvertibleType {
    func track(loading: ActivityTracker, error: ErrorTracker) -> Observable<E> {
        return loading.track(source: self).track(error: error)
    }
    
    private func track(error: ErrorTracker) -> Observable<E> {
        return error.track(source: self)
    }
    private func track(loading: ActivityTracker) -> Observable<E> {
        return loading.track(source: self)
    }
}

extension Reactive where Base: UIViewController {
    
    var viewDidLoad: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }.mapToVoid()
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

public extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return .just(Void())
    }
}

extension Int {
    func toTimeFormat() {
        
    }
}

//
//  MenuInteractor.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import RxCocoa
import RxSwiftExt

protocol MenuInteractorLogic  {
    var inputs: MenuInteractorInput { get }
    var outputs: MenuInteractorOutput { get }
}

protocol MenuInteractorInput {
    var fetchMenus: PublishSubject<MenuCategory> { get }
}

protocol MenuInteractorOutput {
    var responseMenus: Driver<[Menu]> { get }
    var responseError: Driver<APIError> { get }
    var responseLoading: Driver<Bool> { get }
}

class MenuInteractor: MenuInteractorLogic, MenuInteractorInput, MenuInteractorOutput {
    
    var inputs: MenuInteractorInput { return self }
    var outputs: MenuInteractorOutput { return self }
    
    let fetchMenus: PublishSubject<MenuCategory> = .init()
    let responseMenus: Driver<[Menu]>
    let responseError: Driver<APIError>
    let responseLoading: Driver<Bool>
    
    var presenter: MenuPresenterLogic?
    
    init() {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        let response = self.fetchMenus
            .flatMapLatest {
                MenuApiService.shared
                    .getMenus(category: $0)
                    .materialize()
                    .track(error: errorTracker)
                    .track(loading: activityTracker)
            }
            .share()
        
        responseMenus = response.map({ $0.element?.data ?? [] })
            .asDriver(onErrorJustReturn: [])
        
        responseError = errorTracker.asDriver()
            .map { $0.toAPIError() }
        
        responseLoading = activityTracker.asDriver()
    }
}

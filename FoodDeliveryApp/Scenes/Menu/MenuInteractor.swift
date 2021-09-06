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
    // Input
    let fetchMenus: PublishSubject<MenuCategory> = .init()
    // Output
    let responseMenus: Driver<[Menu]>
    let responseError: Driver<APIError>
    let responseLoading: Driver<Bool>
    
    var presenter: MenuPresenterLogic?
    
    init() {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        let menuResponse = fetchMenus
            .flatMap { category -> Observable<[Menu]> in
                switch category {
                case .pizza:
                    return Current.menuApiService
                        .getPizzaMenus()
                        .map({ $0.data.orElse([]) })
                        .track(loading: activityTracker, error: errorTracker)
                case .sushi:
                    return Current.menuApiService
                        .getSushiMenus()
                        .map({ $0.data.orElse([]) })
                        .track(loading: activityTracker, error: errorTracker)
                case .drinks:
                    return Current.menuApiService
                        .getDrinkMenus()
                        .map({ $0.data.orElse([]) })
                        .track(loading: activityTracker, error: errorTracker)
                }
            }
     
        responseMenus = menuResponse.materialize()
            .elements()
            .asDriver(onErrorJustReturn: [])

        responseError = errorTracker.asDriver()
            .map { $0.toAPIError() }
        
        responseLoading = activityTracker.asDriver()
    }
}

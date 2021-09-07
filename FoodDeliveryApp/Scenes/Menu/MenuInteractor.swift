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
    var currentOrderItems: PublishSubject<[OrderItem]> { get }
    var fetchMenus: PublishSubject<MenuCategory> { get }
    var addMenu: PublishSubject<Menu> { get }
}

protocol MenuInteractorOutput {
    var responseMenus: Driver<[Menu]> { get }
    var responseOrders: Driver<[OrderItem]> { get }
    var responseError: Driver<APIError> { get }
    var responseLoading: Driver<Bool> { get }
}

class MenuInteractor: MenuInteractorLogic, MenuInteractorInput, MenuInteractorOutput {
    
    var inputs: MenuInteractorInput { return self }
    var outputs: MenuInteractorOutput { return self }
    // Input
    let fetchMenus: PublishSubject<MenuCategory> = .init()
    let currentOrderItems: PublishSubject<[OrderItem]> = .init()
    let addMenu: PublishSubject<Menu> = .init()
    // Output
    let responseMenus: Driver<[Menu]>
    let responseOrders: Driver<[OrderItem]>
    let responseError: Driver<APIError>
    let responseLoading: Driver<Bool>
    
    var presenter: MenuPresenterLogic?
    
    private let bag = DisposeBag()
    
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
        
        // Add Menu
        let addMenuEvent = addMenu.withLatestFrom(
            Observable.combineLatest(addMenu, currentOrderItems.startWith([]))
        )
        
        responseOrders = addMenuEvent
            .flatMap { (menu, orderItems) -> Observable<[OrderItem]> in
                var newOrderItems: [OrderItem] =  orderItems
                if orderItems.contains(where: { $0.menu.id == menu.id }) {
                    newOrderItems.enumerated().forEach { index, orderItem in
                        if orderItem.menu.id == menu.id {
                            newOrderItems[index].qty += 1
                        }
                    }
                } else {
                    var category: MenuCategory = .pizza
                    switch menu {
                    case is PizzaMenu:
                        category = .pizza
                    case is SushiMenu:
                        category = .sushi
                    case is DrinkMenu:
                        category = .drinks
                    default: break
                    }
                    newOrderItems.append(OrderItem(menu: menu, category: category))
                }
                return Observable.just(newOrderItems)
            }
            .asDriver(onErrorJustReturn: [])
        
        // note: - update current order item input sequence
        responseOrders
            .drive { orderItems in
                self.currentOrderItems.onNext(orderItems)
            }
            .disposed(by: bag)
    }
}

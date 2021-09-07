//
//  MenuPresenter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import RxCocoa

typealias MenuPresenterDependencies = (
    interactor: MenuInteractorLogic,
    router: MenuRouterLogic
)

protocol MenuPresenterInput {
    var addMenuTrigger: PublishSubject<Menu> { get }
    var fetchMenusTrigger: PublishSubject<MenuCategory> { get }
    var cartUpdated: PublishSubject<[OrderItem]> { get }
}

protocol MenuPresenterOutput {
    var menus: BehaviorRelay<[Menu]> { get }
    var orderItems: BehaviorRelay<[OrderItem]> { get }
    var error: PublishSubject<APIError> { get }
    var loading: PublishSubject<Bool> { get }
}

protocol MenuPresenterLogic {
    var inputs: MenuPresenterInput { get }
    var outputs: MenuPresenterOutput { get }
}

class MenuPresenter: MenuPresenterLogic, MenuPresenterInput, MenuPresenterOutput {
    // Input
    let addMenuTrigger: PublishSubject<Menu> = .init()
    let fetchMenusTrigger: PublishSubject<MenuCategory> = .init()
    let cartUpdated: PublishSubject<[OrderItem]> = .init()
    
    // Output
    let menus: BehaviorRelay<[Menu]> = .init(value: [])
    let orderItems: BehaviorRelay<[OrderItem]> = .init(value: [])
    let error: PublishSubject<APIError> = .init()
    let loading: PublishSubject<Bool> = .init()
    
    var inputs: MenuPresenterInput { return self }
    var outputs: MenuPresenterOutput { return self }
    
    private let dependencies: MenuPresenterDependencies
    private let bag = DisposeBag()
    
    init(dependencies: MenuPresenterDependencies) {
        self.dependencies = dependencies
        
        // Input
        // notify interactor to call menu api
        // add some delay
        fetchMenusTrigger.debounce(.init(0.25), scheduler: MainScheduler.instance)
            .bind(to: dependencies.interactor.inputs.fetchMenus)
            .disposed(by: bag)
        
        addMenuTrigger.bind(to: dependencies.interactor.inputs.addMenu)
            .disposed(by: bag)
        
        // whenever cart updated, need to update current output order items
        
        cartUpdated.bind(to: self.orderItems)
            .disposed(by: bag)
        
        cartUpdated
            .bind(to: dependencies.interactor.inputs.currentOrderItems)
            .disposed(by: bag)
        
        // Output
        // output from interactor and bind it to presenter
        dependencies.interactor.outputs.responseMenus
            .drive(self.menus)
            .disposed(by: bag)
        
        dependencies.interactor.outputs.responseError
            .drive(self.error)
            .disposed(by: bag)
        
        dependencies.interactor.outputs.responseLoading
            .drive(self.loading)
            .disposed(by: bag)
        
        dependencies.interactor.outputs.responseOrders
            .drive(self.orderItems)
            .disposed(by: bag)
    }
}

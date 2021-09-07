//
//  CartPresenter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 07/09/2021.
//

import RxSwift
import RxCocoa

struct CartEntryEntity {
    let orderItems: [OrderItem]
}

typealias CartPresenterDependencies = (
    interactor: CartInteractorLogic,
    router: CartRouterLogic
)

protocol CartPresenterInput {
    var entryEntity: BehaviorSubject<CartEntryEntity?> { get }
    var viewDidLoad: PublishSubject<Void> { get }
    var deleteOrderItemTrigger: PublishSubject<OrderItem> { get }
}

protocol CartPresenterOutput {
    var currentOrderItems: BehaviorRelay<[OrderItem]> { get }
    var totalPrice: BehaviorSubject<String?> { get }
    var cartUpdated: PublishSubject<(MenuCategory, [OrderItem])> { get }
}

protocol CartPresenterLogic {
    var inputs: CartPresenterInput { get }
    var outputs: CartPresenterOutput { get }
}

class CartPresenter: CartPresenterLogic, CartPresenterInput, CartPresenterOutput {
    // Input
    let viewDidLoad: PublishSubject<Void> = .init()
    let entryEntity: BehaviorSubject<CartEntryEntity?> = .init(value: nil)
    let deleteOrderItemTrigger: PublishSubject<OrderItem> = .init()
    
    // Output
    let currentOrderItems: BehaviorRelay<[OrderItem]> = .init(value: [])
    let totalPrice: BehaviorSubject<String?> = .init(value: nil)
    var cartUpdated: PublishSubject<(MenuCategory, [OrderItem])> = .init()
    
    var inputs: CartPresenterInput { return self }
    var outputs: CartPresenterOutput { return self }
    
    private let dependencies: CartPresenterDependencies
    private let bag = DisposeBag()
    
    init(dependencies: CartPresenterDependencies) {
        self.dependencies = dependencies
    
        let viewDidLoadedOrderItems = viewDidLoad
            .withLatestFrom(entryEntity.map({ $0?.orderItems ?? [] }))
        
        viewDidLoadedOrderItems
            .bind(to: currentOrderItems)
            .disposed(by: bag)
        
        // Interactor Input
        
        viewDidLoadedOrderItems
            .map({ $0.first?.menu.currency })
            .map({ $0.orEmpty })
            .bind(to: dependencies.interactor.inputs.currency)
            .disposed(by: bag)
        
        viewDidLoadedOrderItems
            .bind(to: dependencies.interactor.inputs.calculateTotalPrice)
            .disposed(by: bag)
        
        deleteOrderItemTrigger
            .bind(to: dependencies.interactor.inputs.deleteOrderItem)
            .disposed(by: bag)
        
        // Interactor Output
        
        dependencies.interactor.outputs
            .responseTotalPrice
            .drive(totalPrice)
            .disposed(by: bag)
        
        dependencies.interactor.outputs
            .responseCartUpdated
            .drive(cartUpdated)
            .disposed(by: bag)
        
        dependencies.interactor.outputs
            .responseCurrentOrderItems
            .drive(currentOrderItems)
            .disposed(by: bag)
    }
}


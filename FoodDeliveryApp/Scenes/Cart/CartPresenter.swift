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
    var viewDidLoad: PublishSubject<Void> { get }
    var entryEntity: BehaviorSubject<CartEntryEntity?> { get }
}

protocol CartPresenterOutput {
    var orderItems: BehaviorRelay<[OrderItem]> { get }
    var totalPrice: BehaviorSubject<String?> { get }
}

protocol CartPresenterLogic {
    var inputs: CartPresenterInput { get }
    var outputs: CartPresenterOutput { get }
}

class CartPresenter: CartPresenterLogic, CartPresenterInput, CartPresenterOutput {
    // Input
    var entryEntity: BehaviorSubject<CartEntryEntity?> = .init(value: nil)
    let viewDidLoad: PublishSubject<Void> = .init()
    // Output
    let orderItems: BehaviorRelay<[OrderItem]> = .init(value: [])
    var totalPrice: BehaviorSubject<String?> = .init(value: nil)
    
    var inputs: CartPresenterInput { return self }
    var outputs: CartPresenterOutput { return self }
    
    private let dependencies: CartPresenterDependencies
    private let bag = DisposeBag()
    
    init(dependencies: CartPresenterDependencies) {
        self.dependencies = dependencies
    
        let viewDidLoadedOrderItems = viewDidLoad
            .withLatestFrom(entryEntity.map({ $0?.orderItems ?? [] }))
        
        viewDidLoadedOrderItems
            .bind(to: orderItems)
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
        
        // Interactor Output
        dependencies.interactor.outputs
            .responseTotalPrice
            .drive(totalPrice)
            .disposed(by: bag)
    }
}


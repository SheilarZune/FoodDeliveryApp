//
//  CartInteractor.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 07/09/2021.
//


import RxSwift
import RxCocoa
import RxSwiftExt

protocol CartInteractorLogic  {
    var inputs: CartInteractorInput { get }
    var outputs: CartInteractorOutput { get }
}

protocol CartInteractorInput {
    var currency: PublishSubject<String> { get }
    var calculateTotalPrice: PublishSubject<[OrderItem]> { get }
    var deleteOrderItem: PublishSubject<OrderItem> { get }
}

protocol CartInteractorOutput {
    var responseTotalPrice: Driver<String> { get }
    var responseCurrentOrderItems: Driver<[OrderItem]> { get }
    var responseCartUpdated: Driver<(MenuCategory, [OrderItem])> { get }
}

class CartInteractor: CartInteractorLogic, CartInteractorInput, CartInteractorOutput {
    
    var inputs: CartInteractorInput { return self }
    var outputs: CartInteractorOutput { return self }
    
    // Input
    let currency: PublishSubject<String> = .init()
    let calculateTotalPrice: PublishSubject<[OrderItem]> = .init()
    let deleteOrderItem: PublishSubject<OrderItem> = .init()
    
    // Output
    let responseTotalPrice: Driver<String>
    let responseCurrentOrderItems: Driver<[OrderItem]>
    let responseCartUpdated: Driver<(MenuCategory, [OrderItem])>
    
    private let orderItems: BehaviorSubject<[OrderItem]> = .init(value: [])
    private let bag = DisposeBag()
    
    init() {
        
        // save order items
        
        calculateTotalPrice
            .bind(to: orderItems)
            .disposed(by: bag)
                
        // delete order item process
        
        let deleteEvent = deleteOrderItem
            .withLatestFrom(Observable.combineLatest(deleteOrderItem, orderItems))
        
        let deleteResult = deleteEvent
            .flatMap { (deleteOrderItem, orderItems) -> Observable<(MenuCategory, [OrderItem])> in
                var tempOrderItems = orderItems
                tempOrderItems.removeAll(where: { $0.id == deleteOrderItem.id})
                return Observable.just((deleteOrderItem.category, tempOrderItems))
            }
            .share()
        
        responseCurrentOrderItems = deleteResult
            .map({ $0.1 })
            .asDriver(onErrorJustReturn: [])
        
        responseCartUpdated = deleteResult
            .flatMap({ category, remainingOrderItems -> Observable<(MenuCategory, [OrderItem])> in
                return Observable.just((category, remainingOrderItems.filter({ $0.category == category })))
            })
            .asDriver(onErrorDriveWith: .never())
        
        // update order items with remaining order items
        deleteResult
            .map({ $0.1 })
            .bind(to: orderItems)
            .disposed(by: bag)
        
        // total price calculation
        
        let total = Observable.merge(calculateTotalPrice, deleteResult.map { $0.1 })
            .mapMany({ $0.totalPrice() })
            .map({ $0.reduce(0, +) })
            
        responseTotalPrice = Observable.combineLatest(total, currency)
            .map({ $0.0.toCurrency().orEmpty + " " + $0.1 })
            .asDriver(onErrorJustReturn: "")
    }
}



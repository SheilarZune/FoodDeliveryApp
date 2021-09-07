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
}

protocol CartInteractorOutput {
    var responseTotalPrice: Driver<String> { get }
}

class CartInteractor: CartInteractorLogic, CartInteractorInput, CartInteractorOutput {
    
    var inputs: CartInteractorInput { return self }
    var outputs: CartInteractorOutput { return self }
    // Input
    var currency: PublishSubject<String> = .init()
    var calculateTotalPrice: PublishSubject<[OrderItem]> = .init()
    
    // Output
    var responseTotalPrice: Driver<String>
    
    var presenter: CartPresenterLogic?
    
    private let bag = DisposeBag()
    
    init() {
        
        let total = calculateTotalPrice
            .mapMany({ Double($0.qty) * $0.menu.price.orZero })
            .map({ $0.reduce(0, +) })
            
        responseTotalPrice = Observable.combineLatest(total, currency)
            .map({ $0.0.toCurrency().orEmpty + " " + $0.1 })
            .asDriver(onErrorJustReturn: "")
    }
}



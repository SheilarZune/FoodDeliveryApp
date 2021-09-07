//
//  HomePresenter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 07/09/2021.
//

import RxSwift
import RxCocoa

typealias HomePresenterDependencies = (
    interactor: HomeInteractorLogic,
    router: HomeRouterLogic
)

protocol HomePresenterInput {
    var viewCartTrigger: PublishSubject<Void> { get }
    var orderItems: BehaviorSubject<[OrderItem]> { get }
}

protocol HomePresenterOutput{
    
}

protocol HomePresenterLogic {
    var inputs: HomePresenterInput { get }
    var outputs: HomePresenterOutput { get }
}

class HomePresenter: HomePresenterLogic, HomePresenterInput, HomePresenterOutput {
    // Input
    let viewCartTrigger: PublishSubject<Void> = .init()
    let orderItems: BehaviorSubject<[OrderItem]> = .init(value: [])
    // Output
    
    var inputs: HomePresenterInput { return self }
    var outputs: HomePresenterOutput { return self }
    
    private let dependencies: HomePresenterDependencies
    private let bag = DisposeBag()
    
    init(dependencies: HomePresenterDependencies) {
        self.dependencies = dependencies
        viewCartTrigger
            .withLatestFrom(orderItems)
            .map({ CartContainerEntity(orderItems: $0) })
            .bind(onNext: openCartScreen)
            .disposed(by: bag)
    }
    
    private func openCartScreen(entryEntity: CartContainerEntity) {
        dependencies.router.routeToCart(entryEntity: entryEntity)
    }
}

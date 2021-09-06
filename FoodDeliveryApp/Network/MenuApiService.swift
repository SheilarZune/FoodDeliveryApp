//
//  MenuApiService.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import Moya

protocol MenuApiServiceLogic: AnyObject {
    var manager: ApiManager<ApiService> { get set }
    func getPizzaMenus() -> Observable<PizzaMenuResponse>
    func getSushiMenus() -> Observable<SushiMenuResponse>
    func getDrinkMenus() -> Observable<DrinkMenuResponse>
}

extension MenuApiServiceLogic {
    
    func getPizzaMenus() -> Observable<PizzaMenuResponse> {
        manager.request(PizzaMenuResponse.self, .getPizzaMenus)
    }
    
    func getSushiMenus() -> Observable<SushiMenuResponse> {
        manager.request(SushiMenuResponse.self, .getSushiMenus)
    }
    
    func getDrinkMenus() -> Observable<DrinkMenuResponse> {
        manager.request(DrinkMenuResponse.self, .getDrinkMenus)
    }
}

class MenuApiService: MenuApiServiceLogic {
    static let shared: MenuApiService = .init() // Singleton
    
    var manager: ApiManager<ApiService>
    
    private init() {
        manager = .init(provider: MoyaProvider<ApiService>(stubClosure: MoyaProvider.neverStub))
    }
}

class MockMenuApiService: MenuApiServiceLogic {
    static let shared: MockMenuApiService = .init() // Singleton
    
    var manager: ApiManager<ApiService>
    
    private init() {
        manager = .init(provider: MoyaProvider<ApiService>(stubClosure: MoyaProvider.delayedStub(2)))
    }
}

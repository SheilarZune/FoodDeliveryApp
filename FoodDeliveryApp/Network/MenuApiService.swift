//
//  MenuApiService.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import RxSwift
import Moya

protocol MenuApiServiceLogic: AnyObject {
    func getMenus(category: MenuCategory) -> Observable<MenuResponse>
}

class MenuApiService: MenuApiServiceLogic {
    static let shared: MenuApiService = .init() // Singleton
    private var manager: ApiManager<ApiService>
    
    private init() {
        manager = .init()
    }
    
    func getMenus(category: MenuCategory) -> Observable<MenuResponse> {
        // todo: - category
        manager.request(MenuResponse.self, .getMenus)
    }
}

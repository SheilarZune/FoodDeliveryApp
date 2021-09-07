//
//  MenuRouter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import UIKit

protocol MenuRouterLogic: RoutingLogic {
    func routeToMenuDetail()
}

class MenuRouter: MenuRouterLogic {
    
    var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToMenuDetail() {
        // todo: - open detail screen
    }
}

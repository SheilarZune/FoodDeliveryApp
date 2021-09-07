//
//  CartRouter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 07/09/2021.
//

import UIKit

protocol CartRouterLogic: RoutingLogic {
}

class CartRouter: CartRouterLogic {
    var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

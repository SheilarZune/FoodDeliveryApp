//
//  HomeRouter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

protocol HomeRouterLogic: RoutingLogic {
    func routeToCart(entryEntity: CartContainerEntity)
}

class HomeRouter: HomeRouterLogic {
    
    var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToCart(entryEntity: CartContainerEntity) {
        let containerVC = CartContainerVC.screen()
        containerVC.cartVC.presenter.inputs.entryEntity.onNext(.init(orderItems: entryEntity.orderItems))
        if let homeVC = viewController as? HomeVC {
            // notify cart update to home screen
            containerVC.cartVC.presenter.outputs
                .cartUpdated
                .bind(to: homeVC.presenter.outputs.cartUpdated)
                .disposed(by: homeVC.bag)
        }
        viewController?.navigationController?.pushViewController(containerVC, animated: true)
    }
}

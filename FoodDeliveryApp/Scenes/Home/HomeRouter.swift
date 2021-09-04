//
//  HomeRouter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

protocol RoutingLogic: AnyObject {
    var viewController: UIViewController? { get set }
    func routeBack()
}

extension RoutingLogic {
    func routeBack() {
        if viewController?.navigationController == nil {
            viewController?.dismiss(animated: true, completion: nil)
        } else {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}

protocol HomeRoutingLogic: RoutingLogic {
    func routeToCart()
}

class HomeRouter: HomeRoutingLogic {
   
    var viewController: UIViewController?
    
    func routeToCart() {
        let pageVC = SwipePageVC()
        let cartVC = CartVC.screen()
        let orderVC = OrderVC.screen()
        pageVC.childs = [cartVC, orderVC]
        viewController?.navigationController?.pushViewController(pageVC, animated: true)
    }
}

//
//  BaseRouter.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 07/09/2021.
//

import UIKit

protocol RoutingLogic: AnyObject {
    var viewController: UIViewController? { get set }
    init(viewController: UIViewController)
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

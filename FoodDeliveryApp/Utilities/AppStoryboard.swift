//
//  AppStoryboard.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case cart = "Cart"
    case menu = "Menu"
    case order = "Order"
}

protocol AppStoryboard: NSObject {
    static var storyboard: Storyboard { get set }
    static func screen() -> Self
}

extension AppStoryboard  {
    static func screen() -> Self {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
}


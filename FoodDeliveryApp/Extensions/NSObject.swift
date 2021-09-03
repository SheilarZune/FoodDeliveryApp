//
//  NSObject.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import Foundation

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

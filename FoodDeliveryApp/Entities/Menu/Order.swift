//
//  Order.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import ObjectMapper

class PlaceOrderRequest: Mappable {
    var menuIds: [Int]?
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        menuIds     <- map["menuIds"]
    }
}

class OrderItem {
    var menu: Menu
    var qty: Int
    
    init(menu: Menu, qty: Int = 1) {
        self.menu = menu
        self.qty = qty
    }
}


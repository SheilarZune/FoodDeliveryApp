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

class PlaceOrderResponse: BaseResponse {
    // todo: - demo
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

class OrderItem {
    var id: String
    var menu: Menu
    var qty: Int
    var category: MenuCategory
    
    init(menu: Menu, category: MenuCategory, qty: Int = 1) {
        self.id = UUID().uuidString
        self.menu = menu
        self.qty = qty
        self.category = category
    }
    
    func totalPrice() -> Double {
        return menu.price.orZero * Double(qty)
    }
}


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




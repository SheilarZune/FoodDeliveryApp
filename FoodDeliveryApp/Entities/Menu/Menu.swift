//
//  Menu.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import ObjectMapper

class MenuResponse: Mappable {
    var status: String?
    var data: [Menu]?
   
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status      <- map["status"]
        data        <- map["data"]
    }
}

class Menu: Mappable {
    var id: Int?
    var menu: String?
    var desc: String?
    var weight: String?
    var size: String?
    var price: Double?
    var currency: String?
    var image: String?
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id          <- map["id"]
        menu        <- map["menu"]
        desc        <- map["desc"]
        weight      <- map["weight"]
        size        <- map["size"]
        price       <- map["price"]
        currency    <- map["currency"]
        image       <- map["image"]
    }
    
    var priceFormattedText: String {
        return price.orZero.toCurrency().orEmpty + " " + currency.orEmpty
    }
}


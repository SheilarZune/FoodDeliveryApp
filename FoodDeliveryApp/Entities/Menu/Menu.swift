//
//  Menu.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import ObjectMapper

class PizzaMenuResponse: BaseResponse {
    var data: [PizzaMenu]?
   
    override func mapping(map: Map) {
        super.mapping(map: map)
        data        <- map["data"]
    }
}

protocol Menu: Mappable  {
    var id: Int? { get }
    var menu: String? { get }
    var desc: String? { get }
    var price: Double? { get }
    var currency: String? { get }
    var image: String? { get }
    func getFormattedPriceText() -> String
    func getMenuCategory() -> MenuCategory
}

extension Menu {
    func getFormattedPriceText() -> String {
        return price.orZero.toCurrency().orEmpty + " " + currency.orEmpty
    }
    
    func getMenuCategory() -> MenuCategory {
        switch self {
        case is PizzaMenu:
            return .pizza
        case is SushiMenu:
            return .sushi
        case is DrinkMenu:
            return .drinks
        default:
            return .unknown
        }
    }
}

class PizzaMenu: Menu {
    var id: Int?
    var menu: String?
    var desc: String?
    var price: Double?
    var currency: String?
    var image: String?
    
    var weight: String?
    var size: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        menu        <- map["menu"]
        desc        <- map["desc"]
        price       <- map["price"]
        currency    <- map["currency"]
        image       <- map["image"]
        weight      <- map["weight"]
        size        <- map["size"]
    }
}



// Sushi

class SushiMenuResponse: BaseResponse {
    var data: [SushiMenu]?
   
    override func mapping(map: Map) {
        super.mapping(map: map)
        data        <- map["data"]
    }
}

class SushiMenu: Menu {
    var id: Int?
    var menu: String?
    var desc: String?
    var price: Double?
    var currency: String?
    var image: String?
    
    var piece: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        menu        <- map["menu"]
        desc        <- map["desc"]
        price       <- map["price"]
        currency    <- map["currency"]
        image       <- map["image"]
        piece       <- map["piece"]
    }
}

// Drinks

class DrinkMenuResponse: BaseResponse {
    var data: [DrinkMenu]?
   
    override func mapping(map: Map) {
        super.mapping(map: map)
        data        <- map["data"]
    }
}

class DrinkMenu: Menu {
    var id: Int?
    var menu: String?
    var desc: String?
    var price: Double?
    var currency: String?
    var image: String?
    
    var size: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        menu        <- map["menu"]
        desc        <- map["desc"]
        price       <- map["price"]
        currency    <- map["currency"]
        image       <- map["image"]
        size        <- map["size"]
    }
}

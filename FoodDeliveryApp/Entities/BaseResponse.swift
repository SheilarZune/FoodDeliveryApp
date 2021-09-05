//
//  BaseResponse.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import ObjectMapper

class BaseResponse: Mappable {
    var status: String?
   
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status      <- map["status"]
    }
    
    func isSuccess() -> Bool {
        return status == "SUCCESS"
    }
}

//
//  Network.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import Moya

enum Environment {
    case production
    case uat
    case dev
    
    var baseDomain: String {
        switch self {
        case .production:
            return "https://production-jsonkeeper.com" // example url
        case .dev, .uat:
            return "https://jsonkeeper.com"
        }
    }
    
    // real api service for uat, production environments
    // mock for dev environment
    var menuApiService: MenuApiServiceLogic {
        switch self {
        case .production, .uat:
            return MenuApiService.shared
        case .dev:
            return MockMenuApiService.shared
        }
    }
}

enum ApiService {
    case getPizzaMenus
    case getSushiMenus
    case getDrinkMenus
    case placeOrder(request: PlaceOrderRequest) // demo purpose
}

extension ApiService: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Current.baseDomain) else {
            fatalError("Base url could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPizzaMenus:
            return "/b/OGG1"
        case .getSushiMenus:
            return "/b/OGG4"
        case .getDrinkMenus:
            return "/b/OHRJ"
        case .placeOrder:
            return "/placeOrder"
        }
    }
    
    var method: Method {
        switch self {
        case .getPizzaMenus, .getSushiMenus, .getDrinkMenus:
            return .get
        case .placeOrder:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getPizzaMenus:
            return getMockResponseData(filename: "pizza").orElse(Data())
        case .getSushiMenus:
            return getMockResponseData(filename: "sushi").orElse(Data())
        case .getDrinkMenus:
            return getMockResponseData(filename: "drink").orElse(Data())
        case .placeOrder:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getPizzaMenus, .getSushiMenus, .getDrinkMenus:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .placeOrder(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

// utility 
func getMockResponseData(filename: String) -> Data? {
    guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
        return nil
    }
    do {
        return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    } catch (let error) {
        debugPrint(error)
        return nil
    }
}

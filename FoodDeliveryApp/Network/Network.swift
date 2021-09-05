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
            return "https://production-jsonkeeper.com" // demo url
        case .uat:
            return "https://uat-jsonkeeper.com" // demo url
        case .dev:
            return "https://jsonkeeper.com"
        }
    }
}

enum ApiService {
    case getMenus
    case placeOrder(request: PlaceOrderRequest) // demo purpose
    
    static let environment: Environment = .dev
}

extension ApiService: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: ApiService.environment.baseDomain) else {
            fatalError("Base url could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getMenus:
            return "/b/OGG1"
        case .placeOrder:
            return "/placeOrder"
        }
    }
    
    var method: Method {
        switch self {
        case .getMenus:
            return .get
        case .placeOrder:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getMenus:
            return getMockResponseData(filename: "menu").orElse(Data())
        case .placeOrder:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getMenus:
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

//
//  Optional.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import Foundation

public extension Optional {
    // basically this method is used for performing side effect

    func then(_ f: (Wrapped) -> Void) {
        switch self {
        case .some(let value):
            f(value)
        case .none:
            return
        }
    }
    
    func orElse(_ x: Wrapped) -> Wrapped {
        switch self {
        case .none: return x
        case .some(let v): return v
        }
    }
}

public extension Optional where Wrapped == String {
    
    var orEmpty: String {
        switch self {
        case .none: return ""
        case .some(let v): return v
        }
    }
}

public extension Optional where Wrapped == Double {
    
    var orZero: Double {
        switch self {
        case .none: return 0
        case .some(let v): return v
        }
    }
}

public extension Optional where Wrapped == Int {
    
    var orZero: Int {
        switch self {
        case .none: return 0
        case .some(let v): return v
        }
    }
}

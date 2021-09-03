//
//  Color.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import SwiftHEXColors

public enum Color: String {
    
    case WhiteGray = "#F5F5F5"
    
    public func instance() -> UIColor {
        return UIColor(hexString: self.rawValue) ?? .black
    }
}


//
//  Double.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 05/09/2021.
//

import Foundation

public extension Double {
    func toCurrency(withPrefix symbol: String = "") -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        formatter.minimumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        return formatter.string(from: NSNumber(value: self))
    }
    
    func commaFormattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    func digits(count: Int) -> Double {
        let divisor = pow(10.0, Double(count))
        let value = (self * divisor).rounded() / divisor
        return value
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : "\(self.digits(count: 2))"
    }
}

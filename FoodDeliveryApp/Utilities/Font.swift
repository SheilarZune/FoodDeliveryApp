//
//  Font.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

public enum Font: String {

    case Bold = "OpenSans-Bold"
    case BoldItalic = "OpenSans-BoldItalic"
    case CondBold = "OpenSans-CondensedBold"
    case CondLight = "OpenSans-CondensedLight"
    case CondLightItalic = "OpenSans-CondensedLightItalic"
    case Italic = "OpenSans-Italic"
    case Light = "OpenSans-Light"
    case LightItalic = "OpenSansLight-Italic"
    case Regular = "OpenSans"
    case ExtraBold = "OpenSans-Extrabold"
    case ExtraBoldItalic = "OpenSans-ExtraboldItalic"
    case SemiBold = "OpenSans-Semibold"
    case SemiBoldItalic = "OpenSans-SemiboldItalic"
    
    public func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

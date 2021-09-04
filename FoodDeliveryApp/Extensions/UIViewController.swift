//
//  UIViewController.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

public var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

public var topSafeArea: CGFloat {
    return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
}

public var bottomSafeArea: CGFloat {
    return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
}

public var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}

public extension UIViewController {
    
}

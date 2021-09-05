//
//  UIViewController.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

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

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Reactive where Base: UIViewController {
    
    var error: Binder<APIError> {
        return Binder(base) { vc, error in
            vc.showAlert(title: "Error", message: error.message())
        }
    }
    
    var loading: Binder<Bool> {
        return Binder(base) { vc, isLoading in
            if isLoading {
                MBProgressHUD.showAdded(to: vc.view, animated: true)
            } else {
                MBProgressHUD.hide(for: vc.view, animated: true)
            }
            print("isLoading: \(isLoading)")
        }
    }
}


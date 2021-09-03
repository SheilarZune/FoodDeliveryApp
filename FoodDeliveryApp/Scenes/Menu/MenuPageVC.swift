//
//  MenuPageVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip

protocol MenuPageVCDelegate: AnyObject {
    func didLoadedChilds()
}

class MenuPageVC: ButtonBarPagerTabStripViewController {
    
    var childs: [UIViewController] = []
    var buttonBarHeight: CGFloat = 0
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        // 1.
        setupView()
        // 2. important
        super.viewDidLoad()
    }
    
    private func setupView() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemFont = Font.Bold.of(size: 14)
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .yellow
        settings.style.buttonBarHeight = buttonBarHeight
        settings.style.buttonBarItemLeftRightMargin = 20
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarLeftContentInset = 12
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _, changeCurrentIndex: Bool, _) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .black
            
            oldCell?.label.font = Font.Regular.of(size: 22)
            newCell?.label.font = Font.Bold.of(size: 22)
            
            oldCell?.contentView.backgroundColor = .clear
            newCell?.contentView.backgroundColor = .clear
        }
    }
    
    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return childs
    }
   
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            // todo: - 
        }
    }
   
    deinit {
        debugPrint("deinit: \(self.className)")
    }
}

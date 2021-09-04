//
//  SwipePageVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip

protocol SwipePageVCDelegate: AnyObject {
    func didChangePage(to page: Int)
}

class SwipePageVC: ButtonBarPagerTabStripViewController {
    
    var childs: [UIViewController] = []
    var buttonBarHeight: CGFloat = 0
    var scrollView: UIScrollView?
    weak var customDelegate: SwipePageVCDelegate?
    
    override func viewDidLoad() {
        // 1.
        setupView()
        // 2. important
        super.viewDidLoad()
        
        buttonBarView.frame = .init(x: 0, y: 28, width: view.frame.width, height: buttonBarView.frame.height - 28)
    }
    
    private func setupView() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemFont = Font.Bold.of(size: 28)
        settings.style.selectedBarHeight = 0
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .yellow
        settings.style.buttonBarHeight = buttonBarHeight
        settings.style.buttonBarItemLeftRightMargin = 0
        
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarLeftContentInset = -12
        
        
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _, changeCurrentIndex: Bool, _) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .black
            
            oldCell?.label.textAlignment = .left
            newCell?.label.textAlignment = .left
            
            oldCell?.label.font = Font.Regular.of(size: 28)
            newCell?.label.font = Font.Bold.of(size: 28)
            
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
            customDelegate?.didChangePage(to: toIndex)
        }
    }
   
    deinit {
        debugPrint("deinit: \(self.className)")
    }
}


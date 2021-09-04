//
//  OrderVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip

class OrderVC: BaseVC, AppStoryboard, IndicatorInfoProvider {

    static var storyboard: Storyboard = .order
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Orders")
    }
}

//
//  CartVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip

class CartVC: UIViewController, AppStoryboard, IndicatorInfoProvider {
    
    static var storyboard: Storyboard = .cart
    
    @IBOutlet weak var tblCart: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView() 
    }
    
    private func setupView() {
        tblCart.dataSource = self
        tblCart.delegate = self
        tblCart.register(nibs: [CartCell.className, CartFooterCell.className])
        tblCart.contentInset.top = 20
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Cart")
    }
}

extension CartVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.deque(CartFooterCell.self)
            return cell
        default:
            let cell = tableView.deque(CartCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

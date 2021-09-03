//
//  MenuVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip

enum MenuCategory {
    case pizza
    case sushi
    case drinks
    
    var tabBarTitle: String {
        switch self {
        case .pizza:
            return "Pizza"
        case .sushi:
            return "Sushi"
        case .drinks:
            return "Drinks"
        }
    }
}

class MenuVC: UIViewController, AppStoryboard, IndicatorInfoProvider {

    static var storyboard: Storyboard = .main
    
    @IBOutlet weak var tblMenu: UITableView!
    
    private var category: MenuCategory = .pizza
    
    static func create(category: MenuCategory) -> MenuVC {
        let vc = MenuVC.screen()
        vc.category = category
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        tblMenu.dataSource = self
        tblMenu.delegate = self
        tblMenu.register(nib: MenuCell.className)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: category.tabBarTitle)
    }
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(MenuCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

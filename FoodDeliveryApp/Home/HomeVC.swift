//
//  HomeVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import FloatingPanel

class HomeVC: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    
    private var fpc: MenuFloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        let pageVC = MenuPageVC()
        let pizzaVC = MenuVC.create(category: .pizza)
        let sushiVC = MenuVC.create(category: .sushi)
        
        pageVC.childs = [pizzaVC, sushiVC]
        pageVC.buttonBarHeight = topSafeArea + 72
        
        fpc = MenuFloatingPanelController()
        fpc?.layoutChangesDelegate = self
        fpc?.backgroundColor = Color.WhiteGray.instance()
        fpc?.set(contentViewController: pageVC)
        
        pageVC.scrollView = pizzaVC.tblMenu
        if let scrollView = pageVC.scrollView {
            fpc?.track(scrollView: scrollView)
        }
        
        fpc?.set(initialTopInset: containerView.layer.frame.minY, finalTopInset: -(pageVC.buttonBarHeight - statusBarHeight))
        fpc?.addPanel(toParent: self)
    }

}

extension HomeVC: MenuFloatingPanelLayoutChangesDelegate {
    func floatingPanelDidChangeState(to state: FloatingPanelState) {
    }
}

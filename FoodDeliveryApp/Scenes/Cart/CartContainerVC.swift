//
//  CartContainerVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

struct CartContainerEntity {
    let orderItems: [OrderItem]
}

class CartContainerVC: BaseVC, AppStoryboard {

    static var storyboard: Storyboard = .main
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private let bag = DisposeBag()
    
    let cartVC = CartVC.screen()
    let orderVC = OrderVC.screen()
    let infoVC = InformationVC.screen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
       
        let pageVC = SwipePageVC()
        pageVC.buttonBarHeight = 45
        pageVC.buttonBarViewAlignment = .center
        pageVC.childs = [cartVC, orderVC, infoVC]
        
        addChild(pageVC)
        pageVC.view.frame = containerView.bounds
        containerView.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        
        btnBack.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
}

//
//  HomeVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import FloatingPanel
import ImageSlideshow
import RxSwift
import RxCocoa

class HomeVC: BaseVC {
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnCart: FloatingButton!
    @IBOutlet weak var cartItemCountView: UIView!
    
    @IBOutlet weak var lblCartItemCount: UILabel!
    @IBOutlet weak var imageSliderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageSliderHeightConstraint: NSLayoutConstraint!
    
    private let pageVC = SwipePageVC()
    private var fpc: MenuFloatingPanelController?
    private var initialY: CGFloat = 0
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
       
        setupImageSlideShow()
        setupFloatingPanel()
        
        cartItemCountView.cornerRadius = cartItemCountView.frame.height / 2
        view.bringSubviewToFront(btnCart)
        view.bringSubviewToFront(cartItemCountView)
        
        // interactions
        btnCart.rx.tap
            .bind(onNext: {
                let vc = CartContainerVC.screen()
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: bag)
    }
    
    private func setupFloatingPanel() {
        
        let pizzaVC = MenuVC.create(category: .pizza)
        let sushiVC = MenuVC.create(category: .sushi)
        let drinksVC = MenuVC.create(category: .drinks)
        
        pageVC.childs = [pizzaVC, sushiVC, drinksVC]
        pageVC.buttonBarHeight = 78
        pageVC.buttonBarViewAlignment = .bottom
        pageVC.customDelegate = self
        
        fpc = MenuFloatingPanelController()
        fpc?.maxY = containerView.layer.frame.minY
        fpc?.layoutChangesDelegate = self
        fpc?.backgroundColor = Color.WhiteGray.instance()
        fpc?.set(contentViewController: pageVC)
        
        pageVC.scrollView = pizzaVC.tblMenu
        if let scrollView = pageVC.scrollView {
            fpc?.track(scrollView: scrollView)
        }
        
        if hasTopNotch {
            fpc?.set(initialTopInset: containerView.frame.minY, finalTopInset: -(pageVC.buttonBarHeight - statusBarHeight))
        } else {
            fpc?.set(initialTopInset: containerView.frame.minY - 120, finalTopInset: -(pageVC.buttonBarHeight - statusBarHeight))
        }
        
        fpc?.addPanel(toParent: self)
    }
    
    private func setupImageSlideShow() {
        guard let bannerImage = UIImage.banner else {
            debugPrint("no banner image in resource")
            return
        }
        
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 66))
        imageSlideShow.contentScaleMode = .scaleAspectFill
        imageSlideShow.setImageInputs([ImageSource(image: bannerImage),
                                       ImageSource(image: bannerImage),
                                       ImageSource(image: bannerImage)])
    }

}

extension HomeVC: SwipePageVCDelegate {
    func didChangePage(to page: Int) {
        let scrollView = pageVC.childs[page].view.subviews.filter({ $0 is UIScrollView }).first as? UIScrollView
        if let scrollView = scrollView {
            fpc?.track(scrollView: scrollView)
        }
    }
}

extension HomeVC: MenuFloatingPanelLayoutChangesDelegate {
    
    func floatingPanelDidMoved(y: CGFloat) {
        if initialY == 0 {
            initialY = y
        }
       
        let top = initialY - y
        imageSliderTopConstraint.constant = top < 0 ? 0 : -top
        pageVC.buttonBarView.isHidden = y > 0 ? false : true
    }
}

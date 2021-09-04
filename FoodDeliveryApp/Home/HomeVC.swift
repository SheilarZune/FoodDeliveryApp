//
//  HomeVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import FloatingPanel
import ImageSlideshow

class HomeVC: UIViewController {
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var cartItemCountView: UIView!
    
    @IBOutlet weak var lblCartItemCount: UILabel!
    @IBOutlet weak var imageSliderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageSliderHeightConstraint: NSLayoutConstraint!
    
    private var fpc: MenuFloatingPanelController?
    private var initialY: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        btnCart.addShadow(ofColor: .black, offset: .init(width: -1, height: 2), opacity: 0.2)
        
        setupImageSlideShow()
        setupFloatingPanel()
        
        cartItemCountView.cornerRadius = cartItemCountView.frame.height / 2
        view.bringSubviewToFront(btnCart)
        view.bringSubviewToFront(cartItemCountView)
    }
    
    private func setupFloatingPanel() {
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
    
    private func setupImageSlideShow() {
        guard let bannerImage = UIImage.banner else {
            debugPrint("no banner image in resource")
            return
        }
        
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 56))
        imageSlideShow.contentScaleMode = .scaleAspectFill
        imageSlideShow.setImageInputs([ImageSource(image: bannerImage),
                                       ImageSource(image: bannerImage),
                                       ImageSource(image: bannerImage)])
    }

}

extension HomeVC: MenuFloatingPanelLayoutChangesDelegate {
   
    func floatingPanelDidMoved(y: CGFloat) {
        if initialY == 0 {
            initialY = y
        }
        
        let top = initialY - y
        imageSliderTopConstraint.constant = top < 0 ? 0 : -top
        print("top: \(top)")
    }
}

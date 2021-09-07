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
    
    let bag = DisposeBag()
    var presenter: HomePresenterLogic!

    let pizzaVC = MenuVC.create(category: .pizza)
    let sushiVC = MenuVC.create(category: .sushi)
    let drinksVC = MenuVC.create(category: .drinks)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let interactor = HomeInteractor()
        let router = HomeRouter(viewController: self)
        presenter = HomePresenter(dependencies: (interactor: interactor, router: router))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    func setupView() {
       
        setupImageSlideShow()
        setupFloatingPanel()
        
        cartItemCountView.cornerRadius = cartItemCountView.frame.height / 2
        view.bringSubviewToFront(btnCart)
        view.bringSubviewToFront(cartItemCountView)
    }
    
    private func setupBindings() {
        
        // Presenter Input
        Observable.combineLatest(pizzaVC.presenter.outputs.orderItems.asObservable(),
                         sushiVC.presenter.outputs.orderItems.asObservable(),
                         drinksVC.presenter.outputs.orderItems.asObservable())
            .bind(onNext: { [weak self] pizza, sushi, drink in
                let orderItems = pizza + sushi + drink
                self?.presenter.inputs.orderItems.onNext(orderItems)
            })
            .disposed(by: bag)
        
        // Presenter Output
        
        presenter.outputs
            .orderItemCount
            .map({ String($0) })
            .bind(to: lblCartItemCount.rx.text)
            .disposed(by: bag)
        
        presenter.outputs
            .orderItemCount
            .map({ $0 == 0 })
            .bind(to: cartItemCountView.rx.isHidden)
            .disposed(by: bag)
        
        presenter.outputs.cartUpdated
            .bind(onNext: { [weak self] category, orderItems in
                switch category {
                case .pizza:
                    self?.pizzaVC.presenter.inputs.cartUpdated.onNext(orderItems)
                case .sushi:
                    self?.sushiVC.presenter.inputs.cartUpdated.onNext(orderItems)
                case .drinks:
                    self?.drinksVC.presenter.inputs.cartUpdated.onNext(orderItems)
                }
            })
            .disposed(by: bag)
        
        // interactions
        btnCart.rx.tap
            .bind(to: presenter.inputs.viewCartTrigger)
            .disposed(by: bag)
    }
    
    private func setupFloatingPanel() {
        
        pageVC.childs = [pizzaVC, sushiVC, drinksVC]
        pageVC.buttonBarHeight = 80
        pageVC.hasFilterViewIncluded = true
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
            // fpc?.set(initialTopInset: containerView.frame.minY, finalTopInset: -(pageVC.buttonBarHeight - statusBarHeight))
            fpc?.set(initialTopInset: containerView.frame.minY, finalTopInset: 0)
        } else {
            fpc?.set(initialTopInset: containerView.frame.minY - 120, finalTopInset: -20)
        }
        
        fpc?.addPanel(toParent: self)
    }
    
    private func setupImageSlideShow() {
        
        imageSlideShow.slideshowInterval = 3
        imageSlideShow.circular = true
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 72))
        imageSlideShow.contentScaleMode = .scaleAspectFill
        imageSlideShow.setImageInputs([ImageSource(image: UIImage.banner1),
                                       ImageSource(image: UIImage.banner2),
                                       ImageSource(image: UIImage.banner3)])
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
    }
}

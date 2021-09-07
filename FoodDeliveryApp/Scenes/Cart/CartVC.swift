//
//  CartVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class CartVC: UIViewController, AppStoryboard, IndicatorInfoProvider {
    
    static var storyboard: Storyboard = .cart
    
    @IBOutlet weak var tblCart: UITableView!
    
    var presenter: CartPresenterLogic!
    private let bag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let interactor = CartInteractor()
        let router = CartRouter(viewController: self)
        presenter = CartPresenter(dependencies: (interactor: interactor, router: router))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        presenter.inputs.viewDidLoad.onNext(())
    }
    
    private func setupView() {
        tblCart.dataSource = self
        tblCart.delegate = self
        tblCart.register(nibs: [CartCell.className, CartFooterCell.className])
        tblCart.contentInset.top = 20
    }
    
    private func setupBindings() {
        presenter.outputs.orderItems
            .bind(onNext: { [weak self] items in
                print("cart items: \(items.count)")
                self?.tblCart.reloadData()
            })
            .disposed(by: bag)
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
        return section == 1 ? 1 : presenter.outputs.orderItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.deque(CartFooterCell.self)
            cell.lblTotal.text = try? presenter.outputs.totalPrice.value()
            return cell
        default:
            let cell = tableView.deque(CartCell.self)
            cell.orderItem = presenter.outputs.orderItems.value[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

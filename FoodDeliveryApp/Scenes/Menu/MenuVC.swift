//
//  MenuVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import SkeletonView

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

class MenuVC: BaseVC, AppStoryboard, IndicatorInfoProvider {

    static var storyboard: Storyboard = .menu
    
    @IBOutlet weak var tblMenu: UITableView!
    
    var presenter: MenuPresenter!
    private var category: MenuCategory = .pizza
    private let bag = DisposeBag()
    
    static func create(category: MenuCategory) -> MenuVC {
        let vc = MenuVC.screen()
        vc.category = category
        return vc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        presenter.inputs.fetchMenusTrigger.onNext(category)
    }
    
    private func setup() {
        let interactor = MenuInteractor()
        let router = MenuRouter(viewController: self)
        presenter = MenuPresenter(dependencies: (interactor: interactor, router: router))
    }
    
    private func setupView() {
        tblMenu.dataSource = self
        tblMenu.delegate = self
        tblMenu.register(nib: MenuCell.className)
        tblMenu.isSkeletonable = true
    }
    
    private func setupBindings() {
        presenter?.outputs.menus
            .bind(onNext: { [weak self] menus in
                print("menus: \(menus.count)")
                self?.tblMenu.reloadData()
            })
            .disposed(by: bag)
        
        presenter?.outputs.error
            .bind(to: rx.error)
            .disposed(by: bag)
        
        presenter?.outputs.loading
            .bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tblMenu.showAnimatedGradientSkeleton()
                } else {
                    self?.tblMenu.hideSkeleton()
                }
            })
            .disposed(by: bag)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: category.tabBarTitle)
    }
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MenuCell.className
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.outputs.menus.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(MenuCell.self)
        cell.menu = presenter.outputs.menus.value[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MenuVC: MenuCellDelegate {
    
    func add(menu: Menu, of cell: MenuCell) {
        presenter.inputs.addMenuTrigger.onNext(menu)
    }
}

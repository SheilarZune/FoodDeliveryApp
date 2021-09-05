//
//  MenuVC.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import XLPagerTabStrip
import RxSwift

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
    
    private var category: MenuCategory = .pizza
    private var presenter: MenuPresenter!
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
        setup()
        setupView()
        setupBindings()
        presenter.inputs.fetchMenusTrigger.onNext(category)
    }
    
    private func setup() {
        let interactor = MenuInteractor()
        let router = MenuRouter()
        presenter = MenuPresenter(dependencies: (interactor: interactor, router: router))
    }
    
    private func setupView() {
        tblMenu.dataSource = self
        tblMenu.delegate = self
        tblMenu.register(nibs: [MenuFilterCell.className, MenuCell.className])
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
            .bind(to: rx.loading)
            .disposed(by: bag)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: category.tabBarTitle)
    }
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : presenter.outputs.menus.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.deque(MenuFilterCell.self)
            
            return cell
        default:
            let cell = tableView.deque(MenuCell.self)
            cell.menu.onNext(presenter.outputs.menus.value[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
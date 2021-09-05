//
//  MenuCell.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol MenuCellDelegate: AnyObject {
    
}

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var cardView: UIView!
   
    let bag = DisposeBag()
    let menu: PublishSubject<Menu> = .init()
    
    weak var delegate: MenuCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        // show menu data
        menu.bind(to: rx.showMenuData)
            .disposed(by: bag)
    }

    func setupView() {
        selectionStyle = .none
        btnPrice.cornerRadius = btnPrice.frame.height / 2
        btnPrice.addTarget(self, action: #selector(btnPriceTapped), for: .touchUpInside)
    }
    
    @objc func btnPriceTapped(_ sender: UIButton) {
        // animate price button
        let originalText = sender.title(for: .normal).orEmpty
        UIView.animate(withDuration: 0.8, animations: {
            sender.backgroundColor = .green
            sender.setTitle("added + 1", for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, animations: {
                sender.backgroundColor = .black
                sender.setTitle(originalText, for: .normal)
            })
        })
    }
}

extension Reactive where Base: MenuCell {
    var showMenuData: Binder<Menu> {
        return Binder(base) { cell, menu  in
            cell.imgMenu.image = UIImage(named: menu.image.orEmpty)
            cell.lblMenuName.text = menu.menu
            cell.lblDesc.text = menu.desc
            cell.lblSize.text = menu.size
            cell.btnPrice.setTitle(menu.priceFormattedText, for: .normal)
        }
    }
}

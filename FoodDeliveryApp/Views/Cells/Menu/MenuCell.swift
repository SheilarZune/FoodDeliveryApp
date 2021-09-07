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
    func add(menu: Menu, of cell: MenuCell)
}

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var cardView: UIView!
   
    let bag = DisposeBag()
    var menu: Menu? {
        didSet {
            guard let menu = menu else {
                return
            }
            imgMenu.image = UIImage(named: menu.image.orEmpty)
            lblMenuName.text = menu.menu
            lblDesc.text = menu.desc
            
            if let pizzaMenu = menu as? PizzaMenu {
                lblSize.text = pizzaMenu.weight.orEmpty + " " + pizzaMenu.size.orEmpty
            }
            
            if let sushiMenu = menu as? SushiMenu {
                lblSize.text = sushiMenu.piece.orEmpty
            }
            
            if let drinkMenu = menu as? DrinkMenu {
                lblSize.text = drinkMenu.size
            }
            
            btnPrice.setTitle(menu.getFormattedPriceText(), for: .normal)
            hideSkeleton()
        }
    }
    
    weak var delegate: MenuCellDelegate?
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        showSkeleton()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        menu = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        selectionStyle = .none
        btnPrice.cornerRadius = btnPrice.frame.height / 2
        btnPrice.addTarget(self, action: #selector(btnPriceTapped), for: .touchUpInside)
    }
    
    @objc func btnPriceTapped(_ sender: UIButton) {
        // animate price button
        let originalText = sender.title(for: .normal).orEmpty
        UIView.animate(withDuration: 0.4, animations: {
            sender.backgroundColor = .green
            sender.setTitle("added + 1", for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                sender.backgroundColor = .black
                sender.setTitle(originalText, for: .normal)
            }, completion: { [weak self] _ in
                if let strongSelf = self, let menu = strongSelf.menu {
                    strongSelf.delegate?.add(menu: menu, of: strongSelf)
                }
            })
        })
    }
    
    private func showSkeleton() {
        if menu == nil {
            cardView.subviews.forEach { view in
                view.isSkeletonable = true
                view.showAnimatedGradientSkeleton()
            }
        }
    }
    
    private func hideSkeleton() {
        cardView.subviews.forEach { view in
            view.hideSkeleton()
        }
    }
}

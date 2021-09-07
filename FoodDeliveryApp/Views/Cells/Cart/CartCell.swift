//
//  CartCell.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func didTapDeleteButton(of cell: CartCell, deleteOrderItem orderItem: OrderItem)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblMenuItemPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    weak var delegate: CartCellDelegate?
    
    var orderItem: OrderItem? {
        didSet {
            guard let orderItem = orderItem else {
                debugPrint("no menu order item to bind in UI")
                return
            }
            imgMenu.image = UIImage(named: orderItem.menu.image.orEmpty)
            lblMenuName.text = orderItem.menu.menu.orEmpty + " x \(orderItem.qty)"
            lblMenuItemPrice.text = "\(orderItem.totalPrice().toCurrency().orEmpty) \(orderItem.menu.currency.orEmpty)" 
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        btnDelete.addTarget(self, action: #selector(btnDeleteTapped), for: .touchUpInside)
    }
    
    @objc func btnDeleteTapped() {
        guard let orderItem = orderItem else {
            debugPrint("no order item to delete.")
            return
        }
        delegate?.didTapDeleteButton(of: self, deleteOrderItem: orderItem)
    }
}

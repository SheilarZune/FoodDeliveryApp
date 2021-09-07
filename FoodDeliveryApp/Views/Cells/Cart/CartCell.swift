//
//  CartCell.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblMenuItemPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    var orderItem: OrderItem? {
        didSet {
            guard let orderItem = orderItem else {
                debugPrint("no menu order item to bind in UI")
                return
            }
            imgMenu.image = UIImage(named: orderItem.menu.image.orEmpty)
            lblMenuName.text = orderItem.menu.menu.orEmpty + " x \(orderItem.qty)"
            lblMenuItemPrice.text = orderItem.menu.price.orZero.toCurrency().orEmpty + " " + orderItem.menu.currency.orEmpty
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        selectionStyle = .none
    }
}

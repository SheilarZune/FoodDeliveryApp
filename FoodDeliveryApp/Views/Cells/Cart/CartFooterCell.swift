//
//  CartFooterCell.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

class CartFooterCell: UITableViewCell {

    @IBOutlet weak var lblTotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
    }
}

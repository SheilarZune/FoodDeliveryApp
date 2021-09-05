//
//  MenuFilterCell.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit
import TagListView

class MenuFilterCell: UITableViewCell {

    @IBOutlet weak var filterItemsView: TagListView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        selectionStyle = .none
        filterItemsView.addTags(["Spicy", "Vegan"])
    }
}

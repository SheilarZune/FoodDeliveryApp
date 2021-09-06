//
//  FilterView.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 06/09/2021.
//

import UIKit
import TagListView

class FilterView: UIView {
    @IBOutlet weak var filterItemsView: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        filterItemsView.addTags(["Spicy", "Vegan"])
    }
}

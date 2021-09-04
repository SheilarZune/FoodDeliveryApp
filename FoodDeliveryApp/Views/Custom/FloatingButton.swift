//
//  FloatingButton.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

class FloatingButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerRadius = frame.height / 2
        addShadow(ofColor: .black, offset: .init(width: -1, height: 2), opacity: 0.2)
    }
}

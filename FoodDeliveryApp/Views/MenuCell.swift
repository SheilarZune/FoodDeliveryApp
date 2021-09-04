//
//  MenuCell.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 04/09/2021.
//

import UIKit

protocol MenuCellDelegate: AnyObject {
    
}

class MenuCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var cardView: UIView!
   
    weak var delegate: MenuCellDelegate?
    
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
        UIView.animate(withDuration: 0.8, animations: {
            sender.backgroundColor = .green
            sender.setTitle("added + 1", for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, animations: {
                sender.backgroundColor = .black
                sender.setTitle("46 USD", for: .normal)
            })
        })
    }
}

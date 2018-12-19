//
//  ItemTableViewCell.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/17/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemTableViewCell: SwipeTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(item: ShoppingItem) {
        
        nameLabel.text = item.name
        infoLabel.text = item.info
        let priceString = String(format: "%.2f", item.price)
        priceLabel.text = priceString
        quantityLabel.text = "quantity: \(item.quantity)"
        
        infoLabel.sizeToFit()
        priceLabel.sizeToFit()
        quantityLabel.sizeToFit()
        
        if item.image != "" { // having image
            getImageFrom(stringData: item.image) { (image) in
                self.itemImageView.image = image
            }
        } else {
            self.itemImageView.image = UIImage(named: "ShoppingCartEmpty")
        }
        
    }

}

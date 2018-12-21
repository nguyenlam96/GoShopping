//
//  SearchItemTableViewCell.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/21/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemInfoLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(theItem: GroceryItem) {
        
        itemNameLabel.text = theItem.name
        itemInfoLabel.text = theItem.info
        itemPriceLabel.text = "$\(String(format: "%.2f", theItem.price))"
        
        if theItem.image != "" { // having image
            getImageFrom(stringData: theItem.image) { (image) in
                self.itemImageView.image = image
            }
        } else {
            self.itemImageView.image = UIImage(named: "ShoppingCartEmpty")
        }
        
    }

}

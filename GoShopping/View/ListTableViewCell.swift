//
//  ListTableViewCell.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/17/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Functions
    func bindData(item: ShoppingList) {
        
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/yyyy"
        
        nameLabel.text = "\(item.name)"
        totalItemsLabel.text = "Items: \(item.totalItems)"
        let currency = UserDefaults.standard.object(forKey: kCURRENCY) as? String
        let totalPriceString = String(format: "%.1f", item.totalPrice)
        totalPriceLabel.text = "Total \(totalPriceString) " + currency!
        let dateString = currentDateFormatter.string(from: item.date)
        dateLabel.text = dateString
        
        totalPriceLabel.sizeToFit()
        nameLabel.sizeToFit()
        totalItemsLabel.sizeToFit()
        
    }

}

//
//  SwipeCellActionCase.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/18/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation
import UIKit

enum ActionDescription {
    
    case buy
    case trash
    case returnPurchase
    case addToCategory
    
    var title: String {
        switch self {
        case .buy:
            return "Buy"
        case .trash:
            return "Trash"
        case .returnPurchase:
            return "Return"
        case .addToCategory:
            return "Add To Category"
        }
        
    }
    
    var image: UIImage  {
        let imageName: String
        switch self {
        case .buy:
            imageName = "BuyFilled"
        case .trash:
            imageName = "Trash"
        case .returnPurchase:
            imageName = "ReturnFilled"
        case .addToCategory:
            imageName = "addCategory"
        }
        
        return UIImage(named: imageName)!
    }
    
    var color: UIColor {
        switch self {
        case .buy:
            return UIColor.darkGray
        case .trash:
            return UIColor.red
        case .returnPurchase:
            return UIColor.darkGray
        case .addToCategory:
            return UIColor.darkGray
        }
    }
    
}

func getSelectedBackgroundView() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    return view
}

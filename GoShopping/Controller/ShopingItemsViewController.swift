//
//  ShopingItemsViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD
import SwipeCellKit

class ShopingItemsViewController: UIViewController {
    
    // MARK: - Properties
    var theShoppingList: ShoppingList?
    var shoppingItems: [ShoppingItem] = []
    var boughtItems: [ShoppingItem] = []
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnable = true
    // MARK: - IBOutlet

    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadAllItems()
    }
    
    // MARK: - Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        title = "Shopping Items"
    }
    
    // MARK: - IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // instantiate AddItemVC
        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        
        if let theShoppingList = self.theShoppingList {
            addItemVC.theShoppingList = theShoppingList
            self.present(addItemVC, animated: true)
        }
        
    }
    
    // MARK: - Helper Functions
    
    func loadAllItems() {
        guard let theShoppingListID = theShoppingList?.id else {
            return
        }
        firebaseRootRef.child(kSHOPPINGITEM).child(theShoppingListID).queryOrdered(byChild: kSHOPPINGLISTID).queryEqual(toValue: theShoppingListID).observe(.value) {  (snapshot) in
            
            self.shoppingItems.removeAll()
            self.boughtItems.removeAll()
            
            if snapshot.exists() {
                
                let sorted = (snapshot.value as! NSDictionary).allValues as NSArray
                
                for each in sorted {
                    let itemDictionary = each as! [String:Any]
                    if self.isDataComeBackValid(item: itemDictionary) {
                        let currentItem = ShoppingItem(dictionary: itemDictionary)
                        if currentItem.isBought {
                            self.boughtItems.append(currentItem)
                        } else {
                            self.shoppingItems.append(currentItem)
                        }
                    } else {
                        continue
                    }
                }
                print("Number of shoppingItems loaded: \(self.shoppingItems.count)")
                print("Number of boughtItems loaded: \(self.boughtItems.count)")
                self.tableView.reloadData()
            } else {
                KRProgressHUD.showInfo(withMessage: "No snapshot return")
                return
            }
            
        }
    }
    
    func isDataComeBackValid(item: [String:Any]) -> Bool {
        guard
        let _ = item[kNAME] as? String,
        let _ = item[kINFO] as? String,
        let _ = item[kQUANTITY] as? Int,
        let _ = item[kPRICE] as? Float,
        let _ = item[kSHOPPINGITEMID] as? String,
        let _ = item[kSHOPPINGLISTID] as? String,
        let _ = item[kISBOUGHT] as? Bool,
        let _ = item[kIMAGE] as? String
        else {
                return false
        }
        
        return true
    }
    
    func customTableViewSectionHeader(title: String) -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.darkGray
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)

        headerView.addSubview(titleLabel)
        
        return headerView
        
    }

}

extension ShopingItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shoppingItems.count
        } else {
            return boughtItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        var item: ShoppingItem!
        if indexPath.section == 0 {
            item = shoppingItems[indexPath.row]
        } else {
            item = boughtItems[indexPath.row]
        }
        if let unwrapItem = item {
            cell.bindData(item: unwrapItem)
        }
        //cell.bindData(item: item)
        return cell
    }
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Shopping Items"
        } else {
            return "Bought Items"
        }

    }
    */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if section == 0 {
            title = "Shopping Items"
        } else {
            title = "Bought Items"
        }
        return customTableViewSectionHeader(title: title)
    }
    
}

extension ShopingItemsViewController: SwipeTableViewCellDelegate {
    // MARK: - SwipeTableViewCell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        <#code#>
    }

}

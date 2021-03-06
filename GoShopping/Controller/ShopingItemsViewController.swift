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
    var totalPrice: Float = 0
    // MARK: - IBOutlet

    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadAllItems()
        updateItemsAndTotalpriceLabel()
    }
    deinit {
        print("\(#file) is deinitialized")
    }
    // MARK: - Setup
    func setup() {
        KRProgressHUD.dismiss()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        title = theShoppingList?.name
    }
    
    // MARK: - IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addNewItemAction = UIAlertAction(title: "New Item", style: .default) { [unowned self](action) in
            // instantiate AddItemVC
            let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
            if let theShoppingList = self.theShoppingList {
                
                addItemVC.theShoppingList = theShoppingList
                self.present(addItemVC, animated: true)
                
            }
        }
        let selectFromGroceryAction = UIAlertAction(title: "Search From Grocery", style: .default) { [unowned self] (action) in
            
            let searchItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchItemVC") as! SearchItemViewController
            
            searchItemVC.delegate = self
            searchItemVC.selectFromTapBar = false
            
            self.present(searchItemVC, animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            return
        }
        
        ac.addAction(addNewItemAction)
        ac.addAction(selectFromGroceryAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true)
        
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
                self.calTotal()
                self.updateItemsAndTotalpriceLabel()
            } else {
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
    
    func calTotal() {
        
        self.totalPrice = 0
        
        for item in self.shoppingItems {
            self.totalPrice += (item.price * Float(item.quantity) )
        }
        for item in self.boughtItems {
            self.totalPrice += (item.price * Float(item.quantity) )
        }
        
        theShoppingList?.totalPrice = self.totalPrice
        theShoppingList?.totalItems = shoppingItems.count + boughtItems.count
        
        // update total price and items in DB
        theShoppingList?.updateItemInBackground(shoppingList: theShoppingList!, completion: { (error) in
            if error != nil {
                KRProgressHUD.showError()
                return
            }
            return
        })
        
    }
    
    func updateItemsAndTotalpriceLabel() {
        let currency = UserDefaults.standard.object(forKey: kCURRENCY) as? String
        itemsLabel.text = "Items left: \(shoppingItems.count)"
        totalPriceLabel.text = "Total Price: \(currency!) \(String(format: "%.0f", self.totalPrice))"
        tableView.reloadData()
        
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
        
        cell.delegate = self
        cell.selectedBackgroundView = getSelectedBackgroundView()
        
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if section == 0 {
            var totalPriceOfShoppingItems: Float = 0
            for item in shoppingItems {
                totalPriceOfShoppingItems += Float(item.quantity) * item.price
            }
            title = "Items to buy (\(shoppingItems.count): \(totalPriceOfShoppingItems))"
        } else {
            var totalPriceOfBoughtItems: Float = 0
            for item in boughtItems {
                totalPriceOfBoughtItems += Float(item.quantity) * item.price
            }
            title = "Bought items (\(boughtItems.count): \(totalPriceOfBoughtItems))"
        }
        return customTableViewSectionHeader(title: title)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var theItem: ShoppingItem!
        
        theItem = indexPath.section == 0 ? shoppingItems[indexPath.row] : boughtItems[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        let addVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
       // addVC.theShoppingList = self.theShoppingList
        addVC.theShoppingItem = theItem
        
        self.present(addVC, animated: true)
        
    }
    
    
}

extension ShopingItemsViewController: SwipeTableViewCellDelegate {
    // MARK: - SwipeTableViewCell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var item: ShoppingItem!
        if indexPath.section == 0 {
            item = shoppingItems[indexPath.row]
        } else {
            item = boughtItems[indexPath.row]
        }
        
        if orientation == .left { // swipe to the right --> buy
            guard isSwipeRightEnable else {
                return nil
            }
            let buyAction = SwipeAction(style: .default, title: nil) { [unowned self] (action, indexPath) in
                // update DB
                item.isBought = !item.isBought
                item.updateItemInBackground(shoppingItem: item, completion: { (error) in
                    if (error != nil) {
                        KRProgressHUD.showError(withMessage: "Error update item")
                    }
                })
                // move item to another section
                if indexPath.section == 0 {
                    self.shoppingItems.remove(at: indexPath.row)
                    self.boughtItems.append(item)
                } else {
                    self.boughtItems.remove(at: indexPath.row)
                    self.shoppingItems.append(item)
                }
                tableView.reloadData()
            }
            
            let addToCategoryAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                let groceryItem = GroceryItem(shoppingItem: item)
                groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                    if (error != nil) {
                        KRProgressHUD.showError(withMessage: "Something wrong")
                    } else {
                        KRProgressHUD.showSuccess(withMessage: "Added to grocery")
                    }
                })
                tableView.reloadData()
            }
            
            addToCategoryAction.accessibilityLabel = "Add to Category"
            configure(action: addToCategoryAction, with: .addToCategory)
            
            buyAction.accessibilityLabel = item.isBought ? "Buy" : "Return"
            let description: ActionDescription = item.isBought ? .returnPurchase : .buy
            configure(action: buyAction, with: description)
            return [buyAction, addToCategoryAction]
        } else { // swipe to the left --> delete
            let deleteAction = SwipeAction(style: .destructive, title: nil) { [unowned self](action, indexPath) in
                // update DB
                item.deleteItemBackground(shoppingItem: item)
                // move item to another section
                if indexPath.section == 0 {
                    self.shoppingItems.remove(at: indexPath.row)
                } else {
                    self.boughtItems.remove(at: indexPath.row)
                }
                //item.deleteItemBackground(shoppingItem: item)
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
            }
            configure(action: deleteAction, with: .trash)
            return [deleteAction]
        }
    }
    
    func configure(action: SwipeAction, with description: ActionDescription) {
        action.title = description.title
        action.image = description.image
        action.backgroundColor = description.color
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = (orientation == .left) ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        
        return options
        
    }

}

extension ShopingItemsViewController: SearchItemViewControllerDelegate {

    
    func didChooseItem(groceryItem: GroceryItem) {
        print("Did choose \(groceryItem.name)")
        let shoppingItem = ShoppingItem(groceryItem: groceryItem)
        shoppingItem.shoppingListId = theShoppingList!.id
        shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
            
            return (error != nil) ? KRProgressHUD.showError() : KRProgressHUD.showSuccess()
            
        }
    }
    
    
}

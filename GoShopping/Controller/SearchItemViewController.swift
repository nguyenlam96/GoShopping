//
//  SearchItemViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/21/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD

class SearchItemViewController: UIViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    var groceryItems: [GroceryItem] = []
    var theShoppingList: ShoppingList?
    var filteredGroceryItem: [GroceryItem] = []
    
    // MARK: - IBOutlet

    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        loadItems()
    }
    
    // MARK: - Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - IBAction
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let addVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        addVC.isAddingToList = true
        self.present(addVC, animated: true)
    }
    
    
    // MARK: - Helper Functions
    func loadItems() {
        
        firebaseRootRef.child(kGROCERYITEM).child("1234").observe(.value) { [unowned self](snapshot) in
            
            self.groceryItems.removeAll()
            
            if snapshot.exists() {
                
                let groceryList = (snapshot.value as! NSDictionary).allValues as NSArray
                
                for each in groceryList {
                    let itemDictionary = each as! [String:Any]
                    if self.isDataComeBackValid(item: itemDictionary) {
                        let currentItem = GroceryItem(dictionary: itemDictionary)
                        self.groceryItems.append(currentItem)
                    } else {
                        continue
                    }
                }
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
            let _ = item[kPRICE] as? Float,
            let _ = item[kOWNERID] as? String,
            let _ = item[kIMAGE] as? String,
            let _ = item[kGROCERYITEMID] as? String
        else {
                return false
        }
        
        return true
    }
    
    func updateUI() {
    
    }
    
}

extension SearchItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isSearching = searchController.isActive && searchController.searchBar.text != ""
        return isSearching ? filteredGroceryItem.count : groceryItems.count
       // return groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchItem", for: indexPath) as! SearchItemTableViewCell
        var theItem: GroceryItem
        let isSearching = searchController.isActive && searchController.searchBar.text != ""
        theItem = isSearching ? filteredGroceryItem[indexPath.row] : groceryItems[indexPath.row]
        cell.bindData(theItem: theItem)
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete Item
            let isSearching = searchController.isActive && searchController.searchBar.text != ""
            let deleteItem = isSearching ? filteredGroceryItem[indexPath.row] : groceryItems[indexPath.row]
            deleteItem.deleteItemBackground(groceryItem: deleteItem)
            isSearching ? filteredGroceryItem.remove(at: indexPath.row) : groceryItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}


extension SearchItemViewController: UISearchResultsUpdating {
    
    func filterContent(with searchText: String, scope: String = "all") {
        
        self.filteredGroceryItem = groceryItems.filter({ (groceryItem) -> Bool in
            return groceryItem.name.lowercased().contains(searchText.lowercased())
        })
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(with: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    
}

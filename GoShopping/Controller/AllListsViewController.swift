//
//  AllListsViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD
import Firebase

class AllListsViewController: UIViewController {
    
    // MARK: - Properties
    
    var allLists: [ShoppingList] = []
    var listNameTextField: UITextField!
    
    // MARK: - IBOutlet

    @IBOutlet weak var tableView: UITableView!
    
    // // MARK: - ViewLifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.dismiss()
        setup()
        loadList()
    }
    
    deinit {
        print("\(#file) is deinitialized")
    }
    
    // MARK: - Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.title = "Lists"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
    }
    
    // MARK: - IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Create Shopping List", message: "Enter name:", preferredStyle: .alert)
        
        ac.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter name"
            self.listNameTextField = nameTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self](action) in
            if self.listNameTextField.text != "" {
                // save
                self.createShoppingList()
                KRProgressHUD.showSuccess(withMessage: "\(self.listNameTextField.text!) created!")
                //self.tableView.reloadData()
            } else {
                return
            }
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true)
        
    }
    
    // MARK: - Load Item
    
    func loadList() {
        
        firebaseRootRef.child(kSHOPPINGLIST).child(FUser.getCurrentID()!).observe(.value) { [unowned self] (snapshot) in
            
            self.allLists.removeAll()
            
            if snapshot.exists() {
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)] )
                
                for each in sorted {
                    let list = each as! [String:Any]
                    if self.isDataComeBackValid(shoppingListDictionary: list) {
                        self.allLists.append(ShoppingList(dictionary: list))
                    } else {
                        continue
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    // MARK: - Helper Functions
    func createShoppingList() {
        
        let shoppingList = ShoppingList(name: listNameTextField.text!)
        
        shoppingList.saveItemInBackground(shoppingList: shoppingList) { [unowned self] (error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Fail to create shop list")
                return
            }
            self.allLists.append(shoppingList)
        }
        
    }
   
    func isDataComeBackValid(shoppingListDictionary: [String:Any]) -> Bool {
        guard let _ = shoppingListDictionary[kNAME] as? String,
            let _ = shoppingListDictionary[kTOTALPRICE] as? Float,
            let _ = shoppingListDictionary[kTOTALITEMS] as? Int,
            let _ = shoppingListDictionary[kSHOPPINGLISTID] as? String,
            let _  = getCustomDateFormatter().date(from: shoppingListDictionary[kDATE] as! String),
            let _ = shoppingListDictionary[kOWNERID] as? String
            else {
                return false
            }
        return true
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier , identifier == "ListToItemSegue" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let shoppingList = allLists[selectedIndexPath.row]
                let desVC = segue.destination as! ShopingItemsViewController
                desVC.theShoppingList = shoppingList
            }
        }
    }


}
extension AllListsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ListTableViewCell
        
        let theItem = allLists[indexPath.row]
        cell.bindData(item: theItem)
         
        return cell
    }
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let theShoppingList = allLists[indexPath.row]
            theShoppingList.deleteItemBackground(shoppingList: theShoppingList)
            allLists.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

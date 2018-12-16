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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadList()
    }
    
    // MARK: - Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Create Shopping List", message: "Enter name:", preferredStyle: .alert)
        
        ac.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter name"
            self.listNameTextField = nameTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self](action) in
            if self.listNameTextField.text != "" {
                // save
                self.createShoppingList()
                KRProgressHUD.showSuccess(withMessage: "\(self.listNameTextField.text!) created !")
            } else {
                KRProgressHUD.showWarning(withMessage: "Name can't be empty!")
            }
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true)
        
    }
    
    // MARK: - Load Item
    
    func loadList() {
        
//        firebaseRootRef.child(kSHOPPINGLIST).child("1234").observe(.value) { [unowned self] (snapshot) in
//
//        }
        firebaseRootRef.child(kSHOPPINGLIST).child("1234").observeSingleEvent(of: .value) { (snapshot) in
            
            self.allLists.removeAll()
            
            if snapshot.exists() {
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])

                for list in sorted {
                    let currentList = list as! [String:Any]
                    guard let name = currentList[kNAME] as? String,
                          let totalPrice = currentList[kTOTALPRICE] as? Float,
                          let totalItems = currentList[kTOTALITEMS] as? Int,
                          let id = currentList[kSHOPPINGLISTID] as? String,
                          let date  = getCustomDateFormatter().date(from: currentList[kDATE] as! String),
                          let ownerId = currentList[kOWNERID] as? String
                    else {
                        continue
                    }
                    print("Items info: ")
                    print("\(name) - \(totalPrice) - \(totalItems) - \(id) - \(date) - \(ownerId)")
                    let list = ShoppingList(_name: name, _totalPrice: totalPrice, _totalItems: totalItems, _id: id, _date: date, _ownerId: ownerId)
                    self.allLists.append(ShoppingList(dictionary: currentList))
                }
                print("Number of item loaded: \(self.allLists.count)")
                self.tableView.reloadData()
            } else {
                print("Snapshot doesn't exist")
            }
        }
        
    }
    
    // MARK: - Helper Functions
    func createShoppingList() {
        
        let shoppingList = ShoppingList(_name: listNameTextField.text!)
        
        shoppingList.saveItemInBackground(shoppingList: shoppingList) { (error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Error creating shop list")
                return
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
        
        let theItem = allLists[indexPath.row]
        cell.textLabel?.text = theItem.name
         
        return cell
    }
    // MARK: - TableView Delegate Methods
    
}

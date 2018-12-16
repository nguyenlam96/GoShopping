//
//  AllListsViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD

class AllListsViewController: UIViewController {
    
    // MARK: - Properties
    
    var allLists: [ShoppingList] = []
    var shoppingListNameTextField: UITextField!
    
    // MARK: - IBOutlet

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
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
            self.shoppingListNameTextField = nameTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self](action) in
            if self.shoppingListNameTextField.text != "" {
                // save
                self.createShoppingList()
            } else {
                KRProgressHUD.showWarning(withMessage: "Name can't be empty!")
            }
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true)
        
    }
    
    // MARK: - Helper Functions
    func createShoppingList() {
        
        let shoppingList = ShoppingList(_name: shoppingListNameTextField.text!)
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
        return cell
    }
    // MARK: - TableView Delegate Methods
    
}

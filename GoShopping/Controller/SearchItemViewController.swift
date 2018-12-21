//
//  SearchItemViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/21/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit

class SearchItemViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var items: [ShoppingItem] = []
    var theShoppingList: ShoppingList?
    // MARK: - IBOutlet

    
    // MARK: - ViewDidLoad
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
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let addVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddItemViewController
        addVC.isAddingToList = true
        self.present(addVC, animated: true)
    }
    
    
    // MARK: - Helper Functions
    
    
}

extension SearchItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchItem", for: indexPath)
        let item = items[indexPath.row]
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    
}

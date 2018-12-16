//
//  ShopingItemsViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit

class ShopingItemsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - IBOutlet

    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - Helper Functions


}

extension ShopingItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        return cell
    }
    // MARK: - TableView Delegate Methods
    
}

//
//  GroceryItem.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/21/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation
import KRProgressHUD

class GroceryItem {
    
    var name: String
    var info: String
    var price: Float
    var ownerId: String
    var image: String
    var groceryItemId: String
    
    init(name: String, info: String, price: Float, image: String) {
        self.name = name
        self.info = info
        self.price = price
        self.ownerId = FUser.getCurrentID()!
        self.image = image
        self.groceryItemId = ""
    }
    
    init(shoppingItem: ShoppingItem) {
        self.name = shoppingItem.name
        self.info = shoppingItem.info
        self.price = shoppingItem.price
        self.image = shoppingItem.image
        self.ownerId = ("\(FUser.getCurrentID())")
        self.groceryItemId = ""
    }
    
    init(dictionary: [String:Any] ) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.price = dictionary[kPRICE] as! Float
        self.ownerId = dictionary[kOWNERID] as! String
        self.image = dictionary[kIMAGE] as! String
        self.groceryItemId = dictionary[kGROCERYITEMID] as! String
    }
    
    func dictionaryFromItem(item: GroceryItem) -> [String:Any] {
        let dict = [kNAME: item.name,
                    kINFO: item.info,
                    kPRICE: item.price,
                    kOWNERID: item.ownerId,
                    kIMAGE: item.image,
                    kGROCERYITEMID: item.groceryItemId] as [String : Any]
        return dict
    }
    
    func saveItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child(FUser.getCurrentID()!).childByAutoId() // automatically create an unique id
        groceryItem.groceryItemId = ref.key! // assign this unique id to shoppingList ID
        
        let itemDictionary = dictionaryFromItem(item: groceryItem)
        ref.setValue(itemDictionary) { (error, ref) in
            completion(error)
        }
    }
    
    func saveItemInBackground(groceryItem: GroceryItem) {
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child(FUser.getCurrentID()!).childByAutoId() // automatically create an unique id
        groceryItem.groceryItemId = ref.key! // assign this unique id to shoppingList ID
        
        let itemDictionary = dictionaryFromItem(item: groceryItem)
        ref.setValue(itemDictionary) { (error, ref) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Fail to handle")
            } else {
                KRProgressHUD.showSuccess(withMessage: "Handle success")
            }
        }
    }
    

    func updateItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child(FUser.getCurrentID()!).child(groceryItem.groceryItemId)
        ref.setValue(dictionaryFromItem(item: groceryItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
    
    func deleteItemBackground(groceryItem: GroceryItem) {
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child(FUser.getCurrentID()!).child(groceryItem.groceryItemId)
        ref.removeValue()
        
    }
    
    
}

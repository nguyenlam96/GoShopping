//
//  GroceryItem.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/21/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation

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
        self.ownerId = "1234"
        self.image = image
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
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child("1234").childByAutoId() // automatically create an unique id
        groceryItem.groceryItemId = ref.key! // assign this unique id to shoppingList ID
        
        let itemDictionary = dictionaryFromItem(item: groceryItem)
        ref.setValue(itemDictionary) { (error, ref) in
            
            completion(error)
            
        }
    }
    

    func updateItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        ref.setValue(dictionaryFromItem(item: groceryItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
    func deleteItemBackground(groceryItem: GroceryItem) {
        
        let ref = firebaseRootRef.child(kGROCERYITEM).child("1234").child(groceryItem.groceryItemId)
        ref.removeValue()
        
    }
    
    
}

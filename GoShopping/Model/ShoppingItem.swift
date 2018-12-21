//
//  ShoppingItem.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/17/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation

class ShoppingItem {
    
    var name: String
    var info: String
    var quantity: Int
    var price: Float
    var shoppingItemId: String
    var shoppingListId: String
    var isBought: Bool
    var image: String
    
    init(name: String, info: String, quantity: Int, price: Float, shoppingListId: String) {
        self.name = name
        self.info = info
        self.quantity = quantity
        self.price = price
        self.shoppingItemId = ""
        self.shoppingListId = shoppingListId
        self.isBought = false
        self.image = ""
    }
    
    init(name: String, info: String, quantity: Int, price: Float, shoppingListId: String, image: String) {
        self.name = name
        self.info = info
        self.quantity = quantity
        self.price = price
        self.shoppingItemId = ""
        self.shoppingListId = shoppingListId
        self.isBought = false
        self.image = image
    }
    
    init(dictionary: [String:Any] ) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.quantity = dictionary[kQUANTITY] as! Int
        self.price = dictionary[kPRICE] as! Float
        self.shoppingItemId = dictionary[kSHOPPINGITEMID] as! String
        self.shoppingListId = dictionary[kSHOPPINGLISTID] as! String
        self.isBought = dictionary[kISBOUGHT] as! Bool
        self.image = dictionary[kIMAGE] as! String
    }
    
    func dictionaryFromItem(item: ShoppingItem) -> [String:Any] {
        let dict = [kNAME: item.name,
                    kINFO: item.info,
                    kQUANTITY: item.quantity,
                    kPRICE: item.price,
                    kSHOPPINGITEMID: item.shoppingItemId,
                    kSHOPPINGLISTID: item.shoppingListId,
                    kISBOUGHT: item.isBought,
                    kIMAGE: item.image] as [String : Any]
        return dict
    }
    
    func saveItemInBackground(shoppingItem: ShoppingItem, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).childByAutoId() // automatically create an unique id
        shoppingItem.shoppingItemId = ref.key! // assign this unique id to shoppingList ID
        
        let itemDictionary = dictionaryFromItem(item: shoppingItem)
        ref.setValue(itemDictionary) { (error, ref) in
            
            completion(error)
            
        }
    }
    
    func deleteItemBackground(shoppingItem: ShoppingItem) {
        
        let ref = firebaseRootRef.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        ref.removeValue()
        
    }
    
    func updateItemInBackground(shoppingItem: ShoppingItem, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        ref.setValue(dictionaryFromItem(item: shoppingItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
}

//
//  ShoppingList.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation

class ShoppingList {
    
    let name: String
    var totalPrice: Float
    var totalItems: Int
    var id: String
    var date: Date
    var ownerId: String
    
    init(name: String, totalPrice: Float = 0, id: String = "") {
        self.name = name
        self.totalPrice = totalPrice
        self.totalItems = 0
        self.id = id
        self.date = Date()
        self.ownerId = FUser.getCurrentID()!
    }
    
    init(name: String, totalPrice: Float = 0, totalItems: Int, id: String = "", date: Date, ownerId: String) {
        self.name = name
        self.totalPrice = totalPrice
        self.totalItems = totalItems
        self.id = id
        self.date = date
        self.ownerId = ownerId
    }

    init(dictionary: [String:Any] ) {
        self.name = dictionary[kNAME] as! String
        self.totalPrice = dictionary[kTOTALPRICE] as! Float
        self.totalItems = dictionary[kTOTALITEMS] as! Int
        self.id = dictionary[kSHOPPINGLISTID] as! String
        self.date = getCustomDateFormatter().date(from: dictionary[kDATE] as! String)!
        self.ownerId = dictionary[kOWNERID] as! String
    }
    // create dictionary from item values
    func dictionaryFromItem(item: ShoppingList) -> [String:Any] {
        
        let date = getCustomDateFormatter().string(from: item.date) // get dateString
        
        let dict = [kNAME: item.name,
                    kTOTALPRICE: item.totalPrice,
                    kTOTALITEMS: item.totalItems,
                    kSHOPPINGLISTID: item.id,
                    kDATE: date,
                    kOWNERID: item.ownerId] as [String : Any]
        return dict
    }
    
    func saveItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kSHOPPINGLIST).child(FUser.getCurrentID()!).childByAutoId() // automatically create an unique id
        shoppingList.id = ref.key! // assign this unique id to shoppingList ID

        let itemDictionary = dictionaryFromItem(item: shoppingList)
        ref.setValue(itemDictionary) { (error, ref) in

            completion(error)

        }
    }
    
    func deleteItemBackground(shoppingList: ShoppingList) {
        
        let ref = firebaseRootRef.child(kSHOPPINGLIST).child(FUser.getCurrentID()!).child(shoppingList.id)
        ref.removeValue()
        
    }
    
    func updateItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kSHOPPINGLIST).child(FUser.getCurrentID()!).child(shoppingList.id)
        ref.setValue(dictionaryFromItem(item: shoppingList)) { (error, ref) in
            completion(error)
        }
    }
    
}

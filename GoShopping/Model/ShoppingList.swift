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
    
    init(_name: String, _totalPrice: Float = 0, _id: String = "") {
        name = _name
        totalPrice = _totalPrice
        totalItems = 0
        id = _id
        date = Date()
        ownerId = "1234"
    }
    
    init(_name: String, _totalPrice: Float = 0, _totalItems: Int, _id: String = "", _date: Date, _ownerId: String) {
        name = _name
        totalPrice = _totalPrice
        totalItems = _totalItems
        id = _id
        date = _date
        ownerId = _ownerId
    }

    init(dictionary: [String:Any] ) {
        name = dictionary[kNAME] as! String
        totalPrice = dictionary[kTOTALPRICE] as! Float
        totalItems = dictionary[kTOTALITEMS] as! Int
        id = dictionary[kSHOPPINGLISTID] as! String
        date = getCustomDateFormatter().date(from: dictionary[kDATE] as! String)!
        ownerId = dictionary[kOWNERID] as! String
    }
    // create dictionary from item values
    func dictionaryFromItem(item: ShoppingList) -> [String:Any] {
        
        let date = getCustomDateFormatter().string(from: item.date) // get dateString
        
        
        let dict = [kNAME: item.name, kTOTALPRICE: item.totalPrice, kTOTALITEMS: item.totalItems, kSHOPPINGLISTID: item.id, kDATE: date, kOWNERID: item.ownerId] as [String : Any]
        return dict
    }
    
    func saveItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void ) {
        
        let ref = firebaseRootRef.child(kSHOPPINGLIST).child("1234").childByAutoId() // automatically create an unique id
        shoppingList.id = ref.key! // assign this unique id to shoppingList ID

        let itemDictionary = dictionaryFromItem(item: shoppingList)
        ref.setValue(itemDictionary) { (error, ref) in

            completion(error)

        }

        
    }
    
    func deleteItemBackground(shoppingList: ShoppingList) {
        
        let ref = firebaseRootRef.child(kSHOPPINGLIST).child("1234").child(shoppingList.id)
        ref.removeValue()
        
        
    }
    
}

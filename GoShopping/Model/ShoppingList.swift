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
    
    
    // create item from dictionary values
//    init(dictionary: NSDictionary) {
//        name = dictionary[kNAME] as! String
//        totalPrice = dictionary[kTOTALPRICE] as! Float
//        totalItems = dictionary[kTOTALITEMS] as! Int
//        id = dictionary[kSHOPPINGLISTID] as! String
//        date = getCustomDateFormatter().date(from: dictionary[kDATE] as! String)!
//        ownerId = dictionary[kOWNERID] as! String
//    }
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
        
       // let objects = [item.name, item.totalPrice, item.totalItems, item.id, date, item.ownerId ] as [Any]
//        let keys = [kNAME as NSCopying, kTOTALPRICE as NSCopying, totalItems as NSCopying, kSHOPPINGLISTID as NSCopying, kDATE as NSCopying, kOWNERID as NSCopying]
        //let keys = [kNAME , kTOTALPRICE  , kTOTALITEMS  , kSHOPPINGLISTID  , kDATE  , kOWNERID  ]
        
        let dict = [kNAME: item.name, kTOTALPRICE: item.totalPrice, kSHOPPINGITEM: item.totalItems, kSHOPPINGLISTID: item.id, kDATE: date, kOWNERID: item.ownerId] as [String : Any]
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

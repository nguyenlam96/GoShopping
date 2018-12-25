//
//  FirebaseUser.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/23/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import KRProgressHUD

class FUser {
    
    let userID: String
    let createdTime: Date
    
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    
    
    init(userID: String, createdTime: Date, email: String, firstName: String, lastName: String) {
        self.userID = userID
        self.createdTime = createdTime
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(dictionary: [String:Any]) {
        
        self.userID = dictionary[kOBJECTID] as! String
        self.createdTime = getCustomDateFormatter().date(from: dictionary[kCREATEDAT] as! String )!
        self.email = dictionary[kEMAIL] as! String
        self.firstName = dictionary[kFIRSTNAME] as! String
        self.lastName = dictionary[kLASTNAME] as! String
    }
    
    func dictionary(from user: FUser) -> [String:Any] {
        
        let createdTime =  getCustomDateFormatter().string(from: user.createdTime)
        
        let dict: [String:Any] = [ kOBJECTID: user.userID,
                                   kCREATEDAT: createdTime,
                                   kEMAIL: user.email,
                                   kFIRSTNAME: user.firstName,
                                   kLASTNAME: user.lastName
                                 ]
        return dict
    }
    
    class func getCurrentID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            // having user
            if let userDictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) as? [String:Any] {
                return FUser.init(dictionary: userDictionary)
            }
        }
        return nil
    }
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void ) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (userResult, error) in
            if error != nil {
                completion(error)
                return
            }
            // fetch user from  firebase
            fetchUser(userID: userResult!.user.uid, completion: { (success) in
                if success! {
                    print("Fetch user successfully")
                }
            })
            completion(error)
            
        }
    }
    
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (userResult, error) in
            if error != nil {
                completion(error)
                return
            }
            
            // create new user
            let newUser = FUser(userID: userResult!.user.uid , createdTime: Date(), email: email, firstName: firstName, lastName: lastName)
            saveUserInBackground(fUser: newUser)
            saveUserLocally(fuser: newUser)
            
            completion(error)
        }
    }
    
    // MARK: - Logout User
    class func logOutCurrentUser(completion: @escaping (_ success: Bool?) -> Void ) {
        
        UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
        do {
            try Auth.auth().signOut()
            completion(true) // success
        } catch {
            completion(false) // not success
            print("Couldn't logout: \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Outside functions
func saveUserInBackground(fUser: FUser) {
    let ref = firebaseRootRef.child(kUSER).child(fUser.userID)
    ref.setValue(dictionary(from: fUser))
}

func saveUserLocally(fuser: FUser) {
    UserDefaults.standard.setValue(dictionary(from: fuser), forKey: kCURRENTUSER)
}
func saveUserLocally(userDictionary: [String:Any] ) {
    UserDefaults.standard.setValue(userDictionary, forKey: kCURRENTUSER)
}

func dictionary(from user: FUser) -> [String:Any] {
    let createdTime =  getCustomDateFormatter().string(from: user.createdTime)
    let dict: [String:Any] = [ kOBJECTID: user.userID,
                               kCREATEDAT: createdTime,
                               kEMAIL: user.email,
                               kFIRSTNAME: user.firstName,
                               kLASTNAME: user.lastName
    ]
    return dict
}

func fetchUser(userID: String, completion: @escaping (_ success: Bool?) -> Void ) {
    firebaseRootRef.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userID).observe(.value) { (snapshot) in
        
        if snapshot.exists() {
            let userDict = ((snapshot.value as! NSDictionary).allValues as Array).first! as! [String:Any]
            saveUserLocally(userDictionary: userDict)
            completion(true)
        } else {
            completion(false)
        }
        
    }
}

func resetUserPassword(email: String) {
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        if error != nil {
            KRProgressHUD.showError(withMessage: "Error reseting password")
        } else {
            KRProgressHUD.showSuccess(withMessage: "Check your Email")
        }
    }
}

func cleanFirebaseObserver() {
    firebaseRootRef.child(kUSER).removeAllObservers()
    firebaseRootRef.child(kSHOPPINGLIST).removeAllObservers()
    firebaseRootRef.child(kSHOPPINGITEM).removeAllObservers()
    firebaseRootRef.child(kGROCERYITEM).removeAllObservers()
}

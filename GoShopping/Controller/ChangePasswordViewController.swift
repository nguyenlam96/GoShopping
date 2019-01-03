//
//  ChangePasswordViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 1/3/19.
//  Copyright © 2019 Nguyen Lam. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD


class ChangePasswordViewController: UIViewController {
    
    // MARK: - Properties
    var currentUser = FUser.currentUser()
    
    // MARK: - IBOutlet
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
        dismissKeyboardWhenTappingAround()
    }
    
    deinit {
        print("\(#file) is deinitialized")
    }
    // MARK: - IBAction
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        if validateFields(){ // all fields filled
            KRProgressHUD.showMessage("Wait...")
            
            let credential = EmailAuthProvider.credential(withEmail: currentUser!.email, password: currentPasswordTextField.text!)
            
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { [unowned self](result, error) in
                
                if error != nil {
                    self.messageLabel.textColor = UIColor.orange
                    self.messageLabel.text = "Incorrect current password"
                } else {

                    Auth.auth().currentUser?.updatePassword(to: self.newPasswordTextField.text!, completion: { [unowned self](error) in
                        
                        if error != nil {
                            KRProgressHUD.dismiss()
                            self.messageLabel.textColor = UIColor.orange
                            self.messageLabel.text = "Fail to update password"
                            print("\(error!.localizedDescription)")
                        } else {
                            KRProgressHUD.dismiss()
                            self.messageLabel.textColor = UIColor.green
                            self.messageLabel.text = "Update password successfully"
                            // reset userdefaul
                            
                        }
                        
                    })
                }
               
            })
            
        }
  
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    func validateFields() -> Bool{
        
        if currentPasswordTextField.text == "" {
            currentPasswordTextField.becomeFirstResponder()
        } else if newPasswordTextField.text == "" {
            newPasswordTextField.becomeFirstResponder()
        } else if (newPasswordTextField.text!.count < 6) {
            self.messageLabel.textColor = UIColor.orange
            self.messageLabel.text = "Password have to be >= 6 characters"
            newPasswordTextField.becomeFirstResponder()
        } else if verifyPasswordTextField.text == "" {
            verifyPasswordTextField.becomeFirstResponder()
        } else if (verifyPasswordTextField.text != newPasswordTextField.text){
            self.messageLabel.textColor = UIColor.orange
            self.messageLabel.text = "Verify is not match"
            verifyPasswordTextField.becomeFirstResponder()
        }else {
            return true
        }
        return false
    }
    
    func dismissKeyboardWhenTappingAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
}

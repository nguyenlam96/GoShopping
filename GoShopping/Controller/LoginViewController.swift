//
//  LoginViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/22/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD
import NotificationCenter

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    deinit {
        print("\(#file) is deinitialized")
    }
    // MARK: - Setup
    func setup() {
        dismissKeyboardWhenTappingAround()
    }

    
    // MARK: - IBAction
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            emailTextField.becomeFirstResponder()
        } else if passwordTextField.text == "" {
            passwordTextField.becomeFirstResponder()
        } else {
            // all fields filled
            KRProgressHUD.show(withMessage: "Signing in...")
            
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { [unowned self] (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Fail to login")
                    return
                }
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.view.endEditing(true)
                self.gotoMainView()
                // call MainView
            }
        }
        
        
        
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            emailTextField.becomeFirstResponder()
        } else {
            KRProgressHUD.showMessage("wait...")
            resetUserPassword(email: emailTextField.text!)
        }
//        guard emailTextField.text != "" else {
//            KRProgressHUD.showError(withMessage: "Enter email!")
//            return
//        }
        
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        // because the SignUpButton is directly connect to the segue, doesn't need to process showing SignupVC here
    }
    
    // MARK: - Helper Functions
    func gotoMainView() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        mainVC.selectedIndex = 0
        self.present(mainVC, animated: true)
        print("Load mainView from Login")
    }
    
    func dismissKeyboardWhenTappingAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

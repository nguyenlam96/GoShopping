//
//  LoginViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/22/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappingAround()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard emailTextField.text != "", passwordTextField.text != "" else {
            KRProgressHUD.showError(withMessage: "Username and password required!")
            return
        }
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
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        guard emailTextField.text != "" else {
            KRProgressHUD.showError(withMessage: "Enter email!")
            return
        }
        resetUserPassword(email: emailTextField.text!)
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
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

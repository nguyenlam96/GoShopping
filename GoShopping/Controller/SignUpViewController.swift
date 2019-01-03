//
//  SignUpViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/22/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD

class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboardWhenTappingAround()
    }
    deinit {
        print("\(#file) is deinitialized")
    }
    // MARK: - IBAction
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        
//        guard email != "", password != "", firstName != "", lastName != "" else {
//            KRProgressHUD.showError(withMessage: "All fields required!")
//            return
//        }
//        KRProgressHUD.show(withMessage: "Signing up...") {
//            KRProgressHUD.dismiss()
//        }
        
        if emailTextField.text == ""  {
            emailTextField.becomeFirstResponder()
        } else if passwordTextField.text == "" {
            passwordTextField.becomeFirstResponder()
        } else if firstNameTextField.text == "" {
            firstNameTextField.becomeFirstResponder()
        } else if lastNameTextField.text == "" {
            lastNameTextField.becomeFirstResponder()
        } else {
            // all fields filled
            KRProgressHUD.showMessage("Registering...")
            FUser.registerUserWith(email: email!, password: password!, firstName: firstName!, lastName: lastName!) {
                [unowned self] (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Fail to sign up!")
                    return
                }
                // sign up success
                self.view.endEditing(true)
                self.gotoMainView()
            }
        }
        
        
        
        
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    func gotoMainView() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        mainVC.selectedIndex = 0
        self.present(mainVC, animated: true)
    }
    func dismissKeyboardWhenTappingAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

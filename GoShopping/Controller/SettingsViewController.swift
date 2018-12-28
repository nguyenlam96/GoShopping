//
//  SettingsViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/22/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    let currencyArray = ["USD", "VND", "RU", "EUR", "GBP"]
    var currencyPicker: UIPickerView!
    var currencyString = ""
    // MARK: - IBOutlet
    @IBOutlet weak var signOutButtonOutlet: UIButton!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        loadCurrencyFromUserDefault()
        setUserInfo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    // MARK: - Setup
    func setup() {
        signOutButtonOutlet.layer.cornerRadius = 15
        //setUsername()
        currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyTextField.delegate = self
        currencyTextField.inputView = currencyPicker
    }
    
    func setUserInfo() {
        let userName = FUser.currentUser()?.fullName ?? "User"
        usernameLabel.text = "Hello, \(userName)"
    }
    
    func loadCurrencyFromUserDefault() {
        self.currencyTextField.text = UserDefaults.standard.object(forKey: kCURRENCY) as? String
    }
    // MARK: - IBAction
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
        FUser.logOutCurrentUser { [unowned self](success) in
            if success! {
                cleanFirebaseObserver()
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
                self.present(loginView, animated: true)
            }
        }
        
    }
    @IBAction func backgroundButton(_ sender: UIButton) {
        self.view.endEditing(true)
    }
     
    // MARK: - Helper Functions
    

}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.currencyPicker {
            return currencyArray.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerView == self.currencyPicker) ? currencyArray[row] : ""
    }
    // MARK: - PickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.currencyPicker {
            currencyTextField.text = currencyArray[row]
        }
        UserDefaults.standard.setValue(currencyTextField.text!, forKey: kCURRENCY)
        // update UI
    }
    func saveSettings() {
        UserDefaults.standard.setValue(currencyTextField.text!, forKey: kCURRENCY)
    }
    func updateUI() {
        currencyTextField.text = UserDefaults.standard.object(forKey: kCURRENCY) as? String
    }
}

extension SettingsViewController: UITextFieldDelegate {
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == currencyTextField, currencyTextField.text == "" {
            currencyTextField.text = currencyArray[0]
        }
    }
}

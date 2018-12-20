//
//  AddItemViewController.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/17/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddItemViewController: UIViewController {
    
    // MARK: - Properties
    var theShoppingList: ShoppingList!
    var itemImage: UIImage?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard nameTextField.text != "" else {
            KRProgressHUD.showWarning(withMessage: "Name can't be empty")
            return
        }
        guard quantityTextField.text != "" else {
            KRProgressHUD.showWarning(withMessage: "Quantity can't be empty")
            return
        }
        guard priceTextField.text != "" else {
            KRProgressHUD.showWarning(withMessage: "Price can't be empty")
            return
        }
        saveItem()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        
        let camera = Camera(delegate: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            // show camera
            camera.presentPhotoCamera(target: self, isEditable: true)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            // show photoLibrary or savedPhotos
            camera.presentPhotoLibrary(target: self, isEditable: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(cancel)
        
        present(optionMenu, animated: true)
        
    }
    
    
    // MARK: - Helper Functions
    func saveItem() {
        
        let name = nameTextField.text!
        let price = Float(priceTextField.text!)!
        let quantity = Int(quantityTextField.text!)!
        let info = infoTextField.text!
        
        let shoppingItem = ShoppingItem(name: name, info: info, quantity: quantity, price: price, shoppingListId: theShoppingList.id)
        
        shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
            if error != nil {
                KRProgressHUD.showError(withMessage: "Save error!")
                print("Error is: \(error)")
                return
            } else {
               KRProgressHUD.showSuccess(withMessage: "Item added")
               return
            }
        }
        
    }
    
    
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.itemImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let newImage = itemImage {
            self.itemImageView.image = newImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

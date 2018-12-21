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
    var theItem: ShoppingItem?
    var isAddingToList: Bool?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var vcTitleLabel: UILabel!
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if theItem != nil {
            fillItemInfo()
            vcTitleLabel.text = "Edit item"
        } else {
            vcTitleLabel.text = "Add item"
        }
        
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
    
    func fillItemInfo() {
        // set the textField
        nameTextField.text = self.theItem?.name
        infoTextField.text = self.theItem?.info
        quantityTextField.text = String(self.theItem!.quantity)
        priceTextField.text = String(self.theItem!.price)
        // set the Image
        if theItem!.image != "" {
            getImageFrom(stringData: theItem!.image) { (returnImage) in
                self.itemImage = returnImage
                itemImageView.image = self.itemImage
            }
        } else {
            itemImageView.image = UIImage(named: "ShoppingCartEmpty")
        }
    }
    
    func saveItem() {
        
        let name = nameTextField.text!
        let price = Float(priceTextField.text!)!
        let quantity = Int(quantityTextField.text!)!
        let info = infoTextField.text!
        // encode image to string
        var imageDataString: String?
        if self.itemImage != nil {
            // having image
            let jpegDataImage = self.itemImage!.jpegData(compressionQuality: 0.5)
            if let data = jpegDataImage {
                imageDataString = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            }
        } else {
            imageDataString = ""
        }
        
//        let shoppingItem = ShoppingItem(name: name, info: info, quantity: quantity, price: price, shoppingListId: theShoppingList.id)
//        shoppingItem.image = imageDataString!
        
        if theItem != nil {
            // editing item
            let editedItem = ShoppingItem(name: name, info: info, quantity: quantity, price: price, shoppingListId: theItem!.shoppingItemId)
            editedItem.image = imageDataString!
            
            //shoppingItem.shoppingItemId = theItem!.shoppingItemId
            editedItem.updateItemInBackground(shoppingItem: editedItem) { (error) in
                (error != nil) ? KRProgressHUD.showError(withMessage: "Update fail") : KRProgressHUD.showSuccess(withMessage: "Update success!")
                return
            }
        } else if isAddingToList! {
            // adding to grocery
            let groceryItem = GroceryItem(name: name, info: info, price: price, image: imageDataString!)
            groceryItem.saveItemInBackground(groceryItem: groceryItem) { (error) in
                (error != nil) ? KRProgressHUD.showError() : KRProgressHUD.showSuccess()
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            // create new item to to shopping list
            let shoppingItem = ShoppingItem(name: name, info: info, quantity: quantity, price: price, shoppingListId: theShoppingList.id)
            shoppingItem.image = imageDataString!
            
            shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
                error != nil ? KRProgressHUD.showError(withMessage: "Save error!") : KRProgressHUD.showSuccess(withMessage: "Item added")
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

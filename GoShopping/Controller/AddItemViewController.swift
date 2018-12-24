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
    var theShoppingList: ShoppingList?
    var itemImage: UIImage?
    var theShoppingItem: ShoppingItem?
    var isCreatingNewGroceryItem = false
    var theGroceryItem : GroceryItem?
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
        
        setup()
        
    }
    
    // MARK: - Setup
    func setup() {
        if theShoppingList != nil {
            vcTitleLabel.text = "Add New Item"
        }
        else if theShoppingItem != nil {
            fillItemInfo(with: theShoppingItem!)
            vcTitleLabel.text = "Edit Shopping Item"
        }
        else if theGroceryItem != nil {
            fillItemInfo(with: theGroceryItem!)
            quantityTextField.isEnabled = false
            vcTitleLabel.text = "Edit Grocery Item"
        }
        else if isCreatingNewGroceryItem {
            quantityTextField.isEnabled = false
            vcTitleLabel.text = "Add New Grocery"
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
//        guard quantityTextField.text != "" else {
//            KRProgressHUD.showWarning(withMessage: "Quantity can't be empty")
//            return
//        }
        guard priceTextField.text != "" else {
            KRProgressHUD.showWarning(withMessage: "Price can't be empty")
            return
        }
        
        saveItem()
        
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
    
    func confirmToAddToGroceryList(newShoppingItem: ShoppingItem) {
        
        let ac = UIAlertController(title: "\(newShoppingItem.name)", message: "Do you want to add this item to grocery list", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .destructive) { [unowned self](action) in
            print("Hit No")
            self.dismiss(animated: true, completion: nil)
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // save to grocery list
            let groceryItem = GroceryItem(shoppingItem: newShoppingItem)
            print("Grocery created")
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                (error != nil) ? KRProgressHUD.showError() : KRProgressHUD.showSuccess()
                print("Grocery Saved In background")
            })
            self.dismiss(animated: true, completion: nil)
        }
        ac.addAction(noAction)
        ac.addAction(yesAction)
        self.present(ac, animated: true)
    }
    
    func fillItemInfo(with item: ShoppingItem) {
        // set the textField
        nameTextField.text = self.theShoppingItem?.name
        infoTextField.text = self.theShoppingItem?.info
        quantityTextField.text = String(self.theShoppingItem!.quantity)
        priceTextField.text = String(self.theShoppingItem!.price)
        itemImageView.image = UIImage(named: "ShoppingCartEmpty")
        // set the Image
        if theShoppingItem!.image != "" {
            getImageFrom(stringData: theShoppingItem!.image) { (returnImage) in
                self.itemImage = returnImage
                itemImageView.image = self.itemImage
            }
        }
    }
    
    func fillItemInfo(with item: GroceryItem) {
        // set the textField
        nameTextField.text = item.name
        infoTextField.text = item.info
        priceTextField.text = String(item.price)
        itemImageView.image = UIImage(named: "ShoppingCartEmpty")
        // set the Image
        if item.image != "" {
            getImageFrom(stringData: item.image) { (returnImage) in
                self.itemImage = returnImage
                itemImageView.image = self.itemImage
            }
        }
    }
    
    func saveItem() {
        
        let name = nameTextField.text!
        let price = Float(priceTextField.text!) ?? 0
        let quantity = Int(quantityTextField.text!) ?? 0
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
        
        
        if theShoppingList != nil {
            // create new shopping Item
            let newShoppingItem = ShoppingItem(name: name, info: info, quantity: quantity, price: price, shoppingListId: theShoppingList!.id)
            newShoppingItem.image = imageDataString!
            print("New Shopping Item Created")
            newShoppingItem.saveItemInBackground(shoppingItem: newShoppingItem) { (error) in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Save shopping Item error!")
                }
                print("New shopping Item saved")
            }
            self.confirmToAddToGroceryList(newShoppingItem: newShoppingItem)
            
        }
        else if theShoppingItem != nil {
            // editing shopping item
            let editedShoppingItem = ShoppingItem(name: name, info: info, quantity: quantity, price: price, shoppingListId: theShoppingItem!.shoppingListId)
            editedShoppingItem.isBought = theShoppingItem!.isBought
            editedShoppingItem.shoppingItemId = theShoppingItem!.shoppingItemId
            editedShoppingItem.image = imageDataString!
            //shoppingItem.shoppingItemId = theItem!.shoppingItemId
            editedShoppingItem.updateItemInBackground(shoppingItem: editedShoppingItem) { (error) in
                (error != nil) ? KRProgressHUD.showError(withMessage: "Update fail") : KRProgressHUD.showSuccess(withMessage: "Update success!")
                return
            }
        } else if theGroceryItem != nil {
            // edit grocery item
            let groceryItem = GroceryItem(name: name, info: info, price: price, image: imageDataString!)
            groceryItem.groceryItemId = theGroceryItem!.groceryItemId
            groceryItem.updateItemInBackground(groceryItem: groceryItem) { (error) in
                (error != nil) ? KRProgressHUD.showError(withMessage: "Update fail") : KRProgressHUD.showSuccess(withMessage: "Update success!")
                return
            }
        } else if isCreatingNewGroceryItem {
            // create new grocery item
            let groceryItem = GroceryItem(name: name, info: info, price: price, image: imageDataString!)
            groceryItem.saveItemInBackground(groceryItem: groceryItem) { (error) in
                (error != nil) ? KRProgressHUD.showError() : KRProgressHUD.showSuccess()
                return
            }
        }
    } // end saveItem() here
 
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

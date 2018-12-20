//
//  Camera.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/20/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

class Camera {
    
    var delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    init(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.delegate = delegate
    }
    
    func presentPhotoLibrary(target: UIViewController, isEditable: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            // do not have source for anything, so return
            let ac = UIAlertController(title: "Not Available!", message: "Photo sources is not available", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(acceptAction)
            target.present(ac, animated: true)
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { // source type is photoLibrary
            imagePicker.sourceType = .photoLibrary
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if (availableTypes as Array).contains(type) {
                    // set as defaul
                    imagePicker.mediaTypes = [type]
                    //imagePicker.allowsEditing = isEditable
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) { // source type is savedPhotosAlbums
            imagePicker.sourceType = .savedPhotosAlbum
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if (availableTypes as Array).contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
            let ac = UIAlertController(title: "Can't access!", message: "Can't access to PhotoLibrary or SavedPhoto", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(acceptAction)
            target.present(ac, animated: true)
            return
        }
        
        imagePicker.allowsEditing = isEditable
        imagePicker.delegate = self.delegate
        target.present(imagePicker, animated: true)
        return
        
    } // end presentPhotoLibrary() here
    
    func presentPhotoCamera(target: UIViewController, isEditable: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ac = UIAlertController(title: "Not Available!", message: "Camera source is not available", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(acceptAction)
            target.present(ac, animated: true)
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                if (availableTypes as Array).contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
            imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.rear) ? .rear : .front
        } else {
            let ac = UIAlertController(title: "Can't access!", message: "Can't access to Camera", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(acceptAction)
            target.present(ac, animated: true)
        }
        
        imagePicker.allowsEditing = isEditable
        imagePicker.showsCameraControls = true
        imagePicker.delegate = self.delegate
        target.present(imagePicker, animated: true)
        
    }
    
    
}

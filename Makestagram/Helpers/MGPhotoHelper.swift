//
//  MGHelper.swift
//  Makestagram
//
//  Created by Shreyak Godala on 03/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    
    // MARK :- Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    
    // MARK :- Helper Methods
    
    func presentActionSheet(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get picture from?", preferredStyle: .actionSheet)
        
        if  UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self] action in
                 self.presentImagePickerController(with: .camera, from: viewController)
            })
            
            
            alertController.addAction(capturePhotoAction)
            
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            
            alertController.addAction(uploadAction)
            
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        
        viewController.present(alertController, animated: true)
        
        
        
    }
    
    
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        viewController.present(imagePicker, animated: true)
        
        
    }

}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
    }
}
















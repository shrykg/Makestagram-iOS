//
//  StorageService.swift
//  Makestagram
//
//  Created by Shreyak Godala on 03/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService {
    
    // provide method for uploading images
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void){
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let downloadURL = url {
                    completion(downloadURL)
                }
            })
            
        }
        
        
        
    }
    
}

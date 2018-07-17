//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Shreyak Godala on 06/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        
        let uid = User.current.uid
        let timeStamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timeStamp).jpg")
        
        
        
    }
    
    
    
    
    
    
    
}

//
//  PostService.swift
//  Makestagram
//
//  Created by Shreyak Godala on 05/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func create(for image: UIImage) {
        
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            
            let string = downloadURL.absoluteString
            
            print("imageURL: \(string)")
            let aspectHeight = image.aspectHeight
            
            create(forURLString: string, aspectHeight: aspectHeight)
        }
        
        
        
        
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        
        // create new post in database
        
//        let currentUser = User.current
//
//        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
//
//        let dict = post.dictValue
//
//        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
//
//        postRef.updateChildValues(dict)
        
        let currentUser = User.current
        
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        
        
        UserService.followers(for: currentUser) { (followerUIDs) in
            
            let timelinePostDict = ["poster_uid": currentUser.uid]
            
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            for uid in followerUIDs {
                
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
                

            }
            
            let postDict = post.dictValue
            
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            rootRef.updateChildValues(updatedData)
            
            
            rootRef.updateChildValues(updatedData, withCompletionBlock: { (err, ref) in
                let postCountRef = Database.database().reference().child("users").child(currentUser.uid).child("post_count")
                
                postCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount + 1
                    
                    return TransactionResult.success(withValue: mutableData)
                })
                
                
            })
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            
            LikeService.isPostLiked(post, byCurrentUserWithCompletion: { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            })
            
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

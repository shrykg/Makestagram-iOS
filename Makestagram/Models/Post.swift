//
//  Post.swift
//  Makestagram
//
//  Created by Shreyak Godala on 05/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    
    // Properties and initializers
    
    
    var isLiked = false
    
    var dictValue: [String:Any] {
        
        let createdAgo = creationDate.timeIntervalSince1970
        
        let userDict = ["uid":poster.uid,
                        "username":poster.username]
        
        return ["image_url": imageURL,
                "image_height": imageHeight,
                "created_at": createdAgo,
                "like_count": likeCount,
                "poster": userDict]
        
        
    }
    
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    var likeCount: Int
    let poster: User
    
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageHeight = imageHeight
        self.imageURL = imageURL
        self.creationDate = Date()
        self.likeCount = 0
        self.poster = User.current
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any],
            let likeCount = dict["like_count"] as? Int,
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let userDict = dict["poster"] as? [String:Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else {return nil}
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.likeCount = likeCount
        self.poster = User(uid: uid, username: username)
    
    }
    
    
    
    
}

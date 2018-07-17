//
//  User.swift
//  Makestagram
//
//  Created by Shreyak Godala on 25/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot



class User: NSObject {
    
    var followerCount: Int?
    var followingCount: Int?
    var postCount: Int?
    
    
    
    
    var isFollowed = false
    
    private static var _current: User?
    
    static var current: User {
        
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
        
    }
    
    static func setUser(_ user: User, writeToUserDefaults: Bool = false) {
       
        if writeToUserDefaults {
            
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            
        }
        
        
        
        _current = user
    }
    
    
    let uid: String
    let username: String
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
    }
    
    init?(snapshot: DataSnapshot){
        guard let userDict = snapshot.value as? [String:Any],
              let username = userDict["username"] as? String,
              let followerCount = userDict["follower_count"] as? Int,
              let followingCount = userDict["following_count"] as? Int,
              let postCount = userDict["post_count"] as? Int
            
            else {return nil}
        
        self.uid = snapshot.key
        self.username = username
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.postCount = postCount
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String else {return nil}
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    
}

extension User: NSCoding {
    
    
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
    
}
    
    
    
    
    




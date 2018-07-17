//
//  UserService.swift
//  Makestagram
//
//  Created by Shreyak Godala on 25/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    // put user related networking code here.
    
    static func create(_ user: FIRUser, username:String, completion: @escaping (User?) -> Void) {
        
        let userAttrs: [String: Any] = ["username": username,
                         "follower_count": 0,"following_count": 0, "post_count": 0]
        
        let ref = Database.database().reference().child("users").child(user.uid)
        
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
        
        
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let user = User(snapshot: snapshot) else {return completion(nil)}
            completion(user)
        }
    }
    
    
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {
                    return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] = snapshot.reversed().flatMap {
                guard let post = Post(snapshot: $0) else {
                    return nil
                }
                
                dispatchGroup.enter()
                
                LikeService.isPostLiked(post, byCurrentUserWithCompletion: { (isLiked) in
                    post.isLiked = isLiked
                    
                    dispatchGroup.leave()
                })
                
                return post
                
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
            
        }
        
        
        
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        
        let currentUser = User.current
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let users = snapshot.flatMap(User.init).filter {
                $0.uid != currentUser.uid
            }
            
            let dispatchGroup = DispatchGroup()
            users.forEach({ (user) in
                dispatchGroup.enter()
                
                FollowService.isUserFollowed(user, byCurrentUserWithCompletion: { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                })
            })
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
            
            
            
        }
        
    }
    
    
    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
        
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let followerDict = snapshot.value as? [String:Bool]  else { return
                completion([])
                
            }
            
            let followerKeys = Array(followerDict.keys)
            
            completion(followerKeys)
            
            
        }
        
        
        
        
        
    }
    
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        
        let currentUser = User.current
        
        let timelineRef = Database.database().reference().child("timeline").child(currentUser.uid)
        timelineRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return completion([])}
            
            let dispatchGroup = DispatchGroup()
            
            var posts = [Post]()
            
            for postSnap in snapshot {
                
                guard let postDict = postSnap.value as? [String:Any],
                let posterUID = postDict["poster_uid"] as? String
                
                    else { continue }
                
                dispatchGroup.enter()
                
                PostService.show(forKey: postSnap.key, posterUID: posterUID, completion: { (post) in
                    if let post = post {
                        posts.append(post)
                    }
                    
                    dispatchGroup.leave()
                })
               
                
                
                
            }
            
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts.reversed())
            })
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    static func observeProfile(for user: User, completion: @escaping (DatabaseReference, User?, [Post]) -> Void) -> DatabaseHandle {
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        
      return userRef.observe(.value) { (snapshot) in
            
            guard let user = User(snapshot: snapshot) else {
                return completion(userRef, nil, [])
            }
            
            
            posts(for: user, completion: { (posts) in
                completion(userRef, user, posts)
            })
            
            
            
            
        }
        
        
    }
    
    
    
    
}

//
//  FollowService.swift
//  Makestagram
//
//  Created by Shreyak Godala on 11/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct FollowService {
    
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        let followData = ["follower/\(user.uid)/\(currentUID)":true,
                          "following/\(currentUID)/\(user.uid)":true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            
            // handle following count
            
            let followingCountRef = Database.database().reference().child("users").child(currentUID).child("following_count")
            
            followingCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: {error,_,_ in
                
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                dispatchGroup.leave()
                
            })
            
          // handle followers count
          dispatchGroup.enter()
            
            let followerCountRef = Database.database().reference().child("users").child(user.uid).child("follower_count")
            
            followerCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: {error,_,_ in
                
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                dispatchGroup.leave()
                
            })
            
            
            
            
            
            
            
            
           dispatchGroup.enter()
            
            UserService.posts(for: user, completion: { (posts) in
                let postKeys = posts.flatMap { $0.key }
                
                var followData = [String: Any]()
                
                let timeLinePostDict = ["poster_uid": user.uid]
                
                postKeys.forEach { followData["timeline/\(currentUID)/\($0)"] = timeLinePostDict
                    
                }
                
                ref.updateChildValues(followData, withCompletionBlock: { (err, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    dispatchGroup.leave()
                    
                    
                })
                
            })
            
            
            dispatchGroup.notify(queue: .main, execute: {
                success(true)
            })
            
            
        }
        
        
        
        
    }
    
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        
        let followData = ["follower/\(user.uid)/\(currentUID)": NSNull(),
                          "following/\(currentUID)/\(user.uid)": NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            
            let followingCountRef = Database.database().reference().child("users").child(currentUID).child("following_count")
            
            followingCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount - 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: {error,_,_ in
                
                if let error = error {
                    
                    assertionFailure(error.localizedDescription)
                    
                }
                
                dispatchGroup.leave()
                
                
            })
            
            
          dispatchGroup.enter()
            
            let followerCountRef = Database.database().reference().child("users").child(user.uid).child("follower_count")
            
            followerCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentcount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentcount - 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: {error,_,_ in
                
                if let error = error {
                    
                    assertionFailure(error.localizedDescription)
                    
                    
                }
                
                dispatchGroup.leave()
                
            })
            
            
            
            
            
            
            
            dispatchGroup.enter()
            
            
            
            UserService.posts(for: user, completion: { (posts) in
                let postKeys = posts.flatMap { $0.key }
                
                var unfollowData = [String:Any]()
                
                postKeys.forEach {
                    unfollowData["timeline/\(currentUID)/\($0)"] = NSNull()
                }
                
                ref.updateChildValues(unfollowData, withCompletionBlock: { (err, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    dispatchGroup.leave()
                    
                })
                
                
                
                
                
            })
            
            
            dispatchGroup.notify(queue: .main, execute: {
                success(true)
            })
            
            
            
        }
        
    }
    
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followe: User, success: @escaping (Bool) -> Void) {
        
        if isFollowing {
            followUser(followe, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followe, forCurrentUserWithSuccess: success)
        }
        
        
        
        
        
        
    }
    
    
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String:Bool]{
                success(true)
            } else {
                success(false)
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    
}

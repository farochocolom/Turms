//
//  VoteService.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/24/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct VoteService {
    
    static func upvote(for post: CityPost, success: @escaping (Bool) -> Void){
        guard let key = post.key else {
            return success(false)
        }

        guard let uid = Auth.auth().currentUser?.uid else {return}
        let upvotesRef = Database.database().reference().child("city_posts_upvotes").child(key).child("uids")
        let downvotesRef = Database.database().reference().child("city_posts_downvotes").child(key).child("uids").child(uid)
        
        var completionStatus = false
        
        let upvoteGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInitiated).async {
            downvotesRef.setValue(false)
            upvotesRef.updateChildValues([uid : true]) { (error, _) in
                let cityPostRef = Database.database().reference().child(Constants.DatabaseRef.cityPosts).child(key).child("upvotes_count")
                let cityPostRefDownvote = Database.database().reference().child(Constants.DatabaseRef.cityPosts).child(key).child("downvotes_count")
                //            let cityPostByUserRef = Database.database().reference().child("city_post_by_user").child(post.postById).child(key).child("upvotes_count")
                
                upvoteGroup.enter()
                cityPostRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount + 1
                    
                    return TransactionResult.success(withValue: mutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let err = error {
                        assertionFailure(err.localizedDescription)
                        completionStatus = false
                    } else {
                        completionStatus = true
                    }
                    upvoteGroup.leave()
                })
                
                upvoteGroup.enter()
                cityPostRefDownvote.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount - 1
                    
                    return TransactionResult.success(withValue: mutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let err = error {
                        assertionFailure(err.localizedDescription)
                        completionStatus = false
                    } else {
                        completionStatus = true
                    }
                    
                    upvoteGroup.leave()
                })
                
            }
            upvoteGroup.wait()
            DispatchQueue.main.async {
                success(completionStatus)
            }
        }
        
    }
    
    
    static func downvote(for post: CityPost, success: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }
        
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let downvotesRef = Database.database().reference().child("city_posts_downvotes").child(key).child("uids")
        let upvotesRef = Database.database().reference().child("city_posts_upvotes").child(key).child("uids")
        
        var completionStatus = false
        let downvoteGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInitiated).async {
            upvotesRef.updateChildValues([uid : false])
            
            
            downvotesRef.updateChildValues([uid : true]) { (error, _) in
                let cityPostRef = Database.database().reference().child(Constants.DatabaseRef.cityPosts).child(key).child("downvotes_count")
                let cityPostRefUpvote = Database.database().reference().child(Constants.DatabaseRef.cityPosts).child(key).child("upvotes_count")
    //            let cityPostByUserRef = Database.database().reference().child("city_post_by_user").child(uid).child(key).child("downvotes_count")
                
                downvoteGroup.enter()
                cityPostRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount + 1
                    
                    return TransactionResult.success(withValue: mutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let err = error {
                        assertionFailure(err.localizedDescription)
                        completionStatus = false
                    } else {
                        completionStatus = true
                    }
                    
                    downvoteGroup.leave()
                })
                
                downvoteGroup.enter()
                cityPostRefUpvote.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount - 1
                    
                    return TransactionResult.success(withValue: mutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let err = error {
                        assertionFailure(err.localizedDescription)
                        completionStatus = false
                    } else {
                        completionStatus = true
                    }
                    downvoteGroup.leave()
                })
                
            }
            
            downvoteGroup.wait()
            DispatchQueue.main.async {
                success(completionStatus)
            }
        }
        
    }
    
    static func isPostUpvoted(_ post: CityPost, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("city_posts_upvotes").child(postKey).child("uids")
        let upvoteGroup = DispatchGroup()
        var completionStatus = false
        
        upvoteGroup.enter()
        likesRef.queryEqual(toValue: nil, childKey: Constants.UserDef.uidValue as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String : Bool] else {return}
            
            completionStatus = value[Constants.UserDef.uidValue as! String]!
            upvoteGroup.leave()

        })
        upvoteGroup.notify(queue: .main) {
            completion(completionStatus)
        }
    }
    
    static func isPostDownvoted(_ post: CityPost, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("city_posts_downvotes").child(postKey).child("uids")
        let downvoteGroup = DispatchGroup()
        var completionStatus = false
        
        
        downvoteGroup.enter()
        let uid  = Constants.UserDef.uidValue
        likesRef.queryEqual(toValue: nil, childKey: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String : Bool] else {return}
            
            completionStatus = value[uid]!
            downvoteGroup.leave()
        })
        downvoteGroup.notify(queue: .main) {
            completion(completionStatus)
        }
    }
    
    
    static func setIsUpvoted(_ isLiked: Bool, for post: CityPost, success: @escaping (Bool) -> Void) {
        
        print(isLiked)
        if isLiked {
            upvote(for: post, success: success)
            success(true)
        } else {
            success(false)
        }
    }
    
    
    
    static func setIsDownvoted(_ isDownvoted: Bool, for post: CityPost, success: @escaping (Bool) -> Void) {
        
        if isDownvoted {
            downvote(for: post, success: success)
            success(true)
        } else {
            success(false)
        }
    }
}

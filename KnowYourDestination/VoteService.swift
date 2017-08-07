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
    
    static func vote(for post: CityPost, isVoted: Bool, upVote: Bool, success: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }

        let voteRefString : String!
        let counterVoteRefString : String!
        if upVote {
            voteRefString = "city_posts_upvotes"
            counterVoteRefString = "city_posts_downvotes"
        } else {
            voteRefString = "city_posts_downvotes"
            counterVoteRefString = "city_posts_upvotes"
        }
        var completionStatus = false
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let votesRef = Database.database().reference().child(voteRefString).child(key).child("uids")
        let counterVotesRef = Database.database().reference().child(counterVoteRefString).child(key).child("uids")
        
        let voteGroup = DispatchGroup()
        voteGroup.enter()
        
        

        votesRef.updateChildValues([uid: true]) { (error, _) in
            let cityRefString : String!
            let counterCityRefString : String!
            if upVote {
                cityRefString = "upvotes_count"
                counterCityRefString = "downvotes_count"
            } else {
                cityRefString = "downvotes_count"
                counterCityRefString = "upvotes_count"
            }
            let cityPostRef = Database.database().reference().child(Constants.DatabaseRef.cityPosts).child(key).child(cityRefString)
            let counterCityPostRef = Database.database().reference().child(Constants.DatabaseRef.cityPosts).child(key).child(counterCityRefString)
            
            voteGroup.enter()
            cityPostRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                // Change count for cityPostRef
                if upVote {
                    post.upvoteCount = mutableData.value! as! Int
                } else {
                    post.downvoteCount = mutableData.value! as! Int
                }
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let err = error {
                    assertionFailure(err.localizedDescription)
                    completionStatus = false
                } else {
                    completionStatus = true
                }
                counterVotesRef.updateChildValues([uid : false])
                voteGroup.leave()
            })
            
            if isVoted {
                voteGroup.enter()
                counterCityPostRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount - 1
                    // Change count for counterCityPostRef
                    if upVote {
                        post.downvoteCount = mutableData.value! as! Int
                    } else {
                        post.upvoteCount = mutableData.value! as! Int
                    }
                    
                    
                    return TransactionResult.success(withValue: mutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let err = error {
                        assertionFailure(err.localizedDescription)
                        completionStatus = false
                    } else {
                        completionStatus = true
                    }
//                    counterVotesRef.updateChildValues([uid : false])
                    voteGroup.leave()
                })
                
            }
            voteGroup.leave()
            
            
        }
        voteGroup.wait()
        DispatchQueue.main.async {
            success(completionStatus)
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
        likesRef.queryEqual(toValue: nil, childKey: Constants.UserDef.uidValue).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String : Bool] else {return}
            
            completionStatus = value[Constants.UserDef.uidValue]!
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
    
    static func setIsUpvoted(_ isLiked: Bool, isDownvoted: Bool, for post: CityPost, success: @escaping (Bool) -> Void) {
        if isLiked {
            vote(for: post, isVoted: isDownvoted, upVote: true, success: success)
            success(true)
        } else {
            success(false)
        }
    }
    
    static func setIsDownvoted(_ isDownvoted: Bool, isUpvoted: Bool, for post: CityPost, success: @escaping (Bool) -> Void) {
        if isDownvoted {
            vote(for: post, isVoted: isUpvoted, upVote: false, success: success)
            success(true)
        } else {
            success(false)
        }
    }
}

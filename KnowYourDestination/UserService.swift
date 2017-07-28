//
//  UserService.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/17/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func create(_ firUser: FIRUser, username: String, isTourGuide: Bool, completion: @escaping (User?) -> Void) {
        let userAttrs: [String : Any] = ["username": username,
                                         "profile_image_url" : "http://www.freeiconspng.com/uploads/profile-icon-9.png",
                                         "is_tour_guide" : isTourGuide]
        
        let userRef = Database.database().reference().child(Constants.DatabaseRef.users).child(firUser.uid)
        
        userRef.setValue(userAttrs) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func posts(for user: User, completion: @escaping ([CityPost]) -> Void) {
        let ref = Database.database().reference().child(Constants.CityPost.postByUser).child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [CityPost] =
                snapshot
                    .reversed()
                    .flatMap {
                        guard let post = CityPost(snapshot: $0)
                            else { return nil }
                        
                        dispatchGroup.enter()
                        
                        VoteService.isPostUpvoted(post, byCurrentUserWithCompletion: { (isUpvoted) in
                        
                            post.isUpvoted = isUpvoted
                            
                            dispatchGroup.leave()
                        })
                        
                        return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
}

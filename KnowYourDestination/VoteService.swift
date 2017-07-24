//
//  VoteService.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/24/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct VoteService {
    
    static func create(for post: CityPost, success: @escaping (Bool) -> Void){
        guard let key = post.key else {
            return success(false)
        }
        
        let upvotesRef = Database.database().reference().child("city_posts_upvotes").child(key)
        
        upvotesRef.setValue(true) { (error, _) in
            if let err = error {
                assertionFailure(err.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }

    }
    
    
    static func delete(for post: CityPost, success: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            return success(false)
        }
        
        let likesRef = Database.database().reference().child("city_posts_upvotes").child(key)
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }
    }
}

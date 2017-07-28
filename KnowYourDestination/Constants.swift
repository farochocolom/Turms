//
//  Constants.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/13/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct Constants {
    
    struct Segue {
        
    }
    
    struct UserDef {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let feed = "feed"
        static let isTourGuide = "is_tour_guide"
        static let imageUrl = "profile_image_url"
        static let username = "username"
        
        static let userId = UserDefaults.standard.object(forKey: uid)
        static let uidValue = Auth.auth().currentUser!.uid
    }
    
    struct TravelGuidesDefaults {
        static let city = "city"
        static let reviewCount = "review_count"
        static let tags = "tags"
    }
    
    struct CityPost {
        static let postText = "post_text"
        static let imageUrl = "image_url"
        static let postedBy = "posted_by"
        static let tags = "tags"
        
        static let postByUser = "city_post_by_user"
    }
    
    struct DatabaseRef {
        static let users = "users"
        static let guides = "guides"
        static let cityPosts = "city_posts"
    }
    
    static let databaseReference = Database.database().reference()
}

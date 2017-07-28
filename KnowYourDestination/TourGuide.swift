//
//  TourGuide.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/13/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class TourGuide: NSObject {
    
    // MARK: Properties
    let uid: String
    let city: String
    let reviewCount: Int
    let tags: [String]
    
    init(uid: String, city: String, reviewCount: Int, tags: [String]) {
        
        self.city = city
        self.reviewCount = reviewCount
        self.tags = tags
        self.uid = uid
//        super.init(uid: User.current.uid, username: User.current.username, imageUrl: User.current.profileImageUrl, tourGuide: true)
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let uid = dict["uid"] as? String,
            let city = dict["city"] as? String,
            let reviewCount = dict["review_count"] as? Int,
            let tags = dict["tags"] as? [String]
            else {return nil}
        
        self.city = city
        self.reviewCount = reviewCount
        self.tags = tags
        self.uid = uid
        
//        super.init(snapshot: snapshot)
    }
    
    
    
    private static var _current: TourGuide?
    
    // 2
    static var current: TourGuide {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    class func setCurrent(_ guide: TourGuide, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: guide)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDef.currentUser)
        }
        
        _current = guide
    }
    
}



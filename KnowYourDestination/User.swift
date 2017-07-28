//
//  User.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/13/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    // MARK: Properties
    
    let uid: String
    var username: String
    let profileImageUrl: String
    let isTourGuide: Bool
    
    // MARK: - Init
    
    init(uid: String, username: String, imageUrl: String, tourGuide: Bool) {
        self.uid = uid
        self.username = username
        self.isTourGuide = tourGuide
        self.profileImageUrl = imageUrl
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let imageUrl = dict[Constants.UserDef.imageUrl] as? String,
            let tourGuide = dict[Constants.UserDef.isTourGuide] as? Bool
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.profileImageUrl = imageUrl
        self.isTourGuide = tourGuide
    }

    
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
//        _current?.username = UserDefaults.standard.object(forKey: Constants.UserDefaults.username) as! String
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    class func setCurrent(user: User, _ uid: String, isTourGuide: Bool, username: String, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            UserDefaults.standard.set(uid, forKey: Constants.UserDef.currentUser)
            UserDefaults.standard.set(isTourGuide, forKey: Constants.UserDef.isTourGuide)
            UserDefaults.standard.set(username, forKey: Constants.UserDef.username)
        }
        
        
        _current = user
    }
    
    
}


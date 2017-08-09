//
//  CityPost.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/18/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class CityPost {
    var key: String?
    let text: String
    let imageUrl: String
    let postById: String
    let postByName: String
    let tags: [String]
    var image: UIImage?
    var upvoteCount: Int
    var downvoteCount: Int
    var upvotes: [String]?
    var downvotes: [String]?
    var isUpvoted: Bool
    var isDownvoted: Bool
    var city: String
    
    init(text: String, imageUrl: String, postById: String, postByName: String,
         tags: [String], image: UIImage?, city: String) {
        self.text = text
        self.imageUrl = imageUrl
        self.postByName = postByName
        self.postById = postById
        self.tags = tags
        self.image = image
        self.upvoteCount = 0
        self.downvoteCount = 0
        self.isDownvoted = false
        self.isUpvoted = false
        self.city = city
    }
    
    init?(snapshot: DataSnapshot, upvotesSnapshot: DataSnapshot = DataSnapshot()){
        guard let dict = snapshot.value as? [String: Any],
            let postText = dict["post_text"] as? String,
            let imageUrl = dict["image_url"] as? String,
            let postById = dict["posted_by"] as? String,
            let postByName = dict["posted_by_name"] as? String,
            let tags = dict["tags"] as? [String],
            let upvotesCount = dict["upvotes_count"] as? Int,
            let downvotesCount = dict["downvotes_count"] as? Int,
            let city = dict["city"] as? String
            else {return nil}

        self.key = snapshot.key
        self.text = postText
        self.imageUrl = imageUrl
        self.postByName = postByName
        self.postById = postById
        self.tags = tags
        self.image = UIImage()
        self.downvoteCount = downvotesCount
        self.upvoteCount = upvotesCount
        self.isUpvoted = false
        self.isDownvoted = false
        self.city = city
        
               
    }
    
    
    
}

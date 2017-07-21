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
    let text: String
    let imageUrl: String
    let postById: String
    let postByName: String
    let tags: [String]
    var image: UIImage?
//    var upvotes: Int
//    var downvotes: Int
//    var isUpvoted: Bool
//    var isDownvoted: Bool
    
    init(text: String, imageUrl: String, postById: String, postByName: String, tags: [String], image: UIImage?) {
        self.text = text
        self.imageUrl = imageUrl
        self.postByName = postByName
        self.postById = postById
        self.tags = tags
        self.image = image
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: Any],
            let postText = dict["post_text"] as? String,
            let imageUrl = dict["image_url"] as? String,
            let postById = dict["posted_by"] as? String,
            let postByName = dict["posted_by_name"] as? String,
            let tags = dict["tags"] as? [String]
            else {return nil}

        self.text = postText
        self.imageUrl = imageUrl
        self.postByName = postByName
        self.postById = postById
        self.tags = tags
        self.image = UIImage()
    }
    
    
}

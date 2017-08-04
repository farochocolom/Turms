//
//  CityPostService.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/18/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct CityPostService {
    
    static func create(for image: UIImage, postedBy: String, postedByName: String, postText: String, tags: [String], city: String, completion: @escaping (Bool) -> Void) {
        let uuid = UUID().uuidString
        let dispatchGroup = DispatchGroup()

        if image != UIImage(named: "image"){
            print("hay imagen")
        } else {
            print("no hay imagen")
        }
        
        let storageRef = Storage.storage().reference().child("cityPosts/images/\(postedBy)/\(uuid).png")

        guard let uploadData = UIImagePNGRepresentation(image)
            else {return}
        
        var cityPostAttributes = [String : Any]()
        
        dispatchGroup.enter()
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let err = error {
                print(err.localizedDescription)
                dispatchGroup.leave()
                return
            }
            
            if image != UIImage(named: "image"){
                guard let postImgUrl = metadata?.downloadURL()?.absoluteString
                    else {
                        dispatchGroup.leave()
                        return
                }
                
                cityPostAttributes = ["post_text": postText,
                                        "image_url" : postImgUrl,
                                        "posted_by": postedBy,
                                        "posted_by_name": postedByName,
                                        "tags" : tags,
                                        "city" : city,
                                        "upvotes_count": 0,
                                        "downvotes_count": 0]

            } else {
                cityPostAttributes = ["post_text": postText,
                                        "image_url" : "",
                                        "posted_by": postedBy,
                                        "posted_by_name": postedByName,
                                        "tags" : tags,
                                        "city" : city,
                                        "upvotes_count": 0,
                                        "downvotes_count": 0]
            }
            dispatchGroup.leave()
            
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            create(values: cityPostAttributes, uid: postedBy, completion: { (finished) in
                if finished {
                    completion(true)
                }
            })
        })
    }
    
    static func create(values: [String: Any], uid: String, completion: @escaping (Bool) -> Void) {
        
        let cityPostRef = Database.database().reference().child(Constants.DatabaseRef.cityPosts).childByAutoId()
        let cityPostByUserRef = Database.database().reference().child("city_post_by_user").child(uid).childByAutoId()
        
        cityPostRef.setValue(values) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
            }
            
        }
        
        cityPostByUserRef.setValue(values) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
            }
        }
        
        completion(true)
    }
    
    static func cityPosts(completion: @escaping ([CityPost]) -> Void) {
        let ref = Database.database().reference().child(Constants.DatabaseRef.cityPosts)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            let posts: [CityPost] = snapshot.reversed().flatMap{
                guard let post = CityPost(snapshot: $0)
                    else {return nil}
                
                return post
            }
            
            completion(posts)
        })
    }
}

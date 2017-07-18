//
//  TourGuideService.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/17/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct TourGuideService {
    
    static func create(uid: String, completion: @escaping (TourGuide?) -> Void) {

        let travelGuideAttrs: [String : Any] = ["city": "",
                                                "review_count" : 0,
                                                "tags" : ["Cool"]]
        let guideRef = Database.database().reference().child(Constants.DatabaseRef.guides).child(uid)
        
        guideRef.setValue(travelGuideAttrs) { (error, ref) in
            if let err = error {
                assertionFailure(err.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = TourGuide(snapshot: snapshot)
                completion(user)
            })
        }
    }
}

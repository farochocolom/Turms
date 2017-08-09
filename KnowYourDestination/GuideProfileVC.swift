//
//  GuideProfileVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/3/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import FirebaseAuth

class GuideProfileVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tourGuideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        let isLocalGuide = defaults.bool(forKey: Constants.UserDef.isTourGuide)
//        nameLabel.text = Auth.auth().currentUser?.displayName
        emailLabel.text = "Email: \(Auth.auth().currentUser?.email ?? "No Email found")"
        usernameLabel.text = "Username: \(UserDefaults.standard.string(forKey: Constants.UserDef.username) ?? "no username found")"
        tourGuideLabel.text = "Tour Guide? \(isLocalGuide ? "Yes" : "No")"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
    
        do {
            try firebaseAuth.signOut()
            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                // 3
                self.view.window?.rootViewController = initialViewController
                // 4
                self.view.window?.makeKeyAndVisible()
            }
    
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}

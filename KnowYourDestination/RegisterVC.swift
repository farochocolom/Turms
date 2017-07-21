//
//  RegisterViewController.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/16/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var travelGuideSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            guard let user = user
                else { return }
            
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            
            // 3
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? [String : Any] {
                    let alert = UIAlertController(title: "User Taken", message: "A user with this email already exists", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "A thing", style: .default) { action in
                        
                    })
                } else {
                    UserService.create(user, username: username, isTourGuide: self.travelGuideSwitch.isOn, completion: { (user) in
                        guard let user = user else { return }
                        User.setCurrent(user: user, user.uid, isTourGuide: user.isTourGuide, writeToUserDefaults: true)
                        
                        var storyboard: UIStoryboard
                        if self.travelGuideSwitch.isOn {
                            
                            storyboard = UIStoryboard(name: "Guide", bundle: .main)
                            TourGuideService.create(uid: user.uid, completion: { (tourGuide) in
                                guard let travelGuide = tourGuide else {return}
                                
                                TourGuide.setCurrent(travelGuide, writeToUserDefaults: true)
                            })
                            
                        } else {
                            storyboard = UIStoryboard(name: "Main", bundle: .main)
                        }
                        
                        // 2
                        if let initialViewController = storyboard.instantiateInitialViewController() {
                            // 3
                            self.view.window?.rootViewController = initialViewController
                            // 4
                            self.view.window?.makeKeyAndVisible()
                        }
                    })

                }
            })
        }
    }
}

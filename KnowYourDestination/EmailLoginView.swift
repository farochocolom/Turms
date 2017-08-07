//
//  EmailLoginView.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/12/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase

class EmailLoginView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var isVolunteerTourGuideSwitch: UISwitch!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("EmailLogin", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
//    @IBAction func didPressRegisterButton(_ sender: UIButton) {
//        
//        if let email = emailTextField.text, let password = passwordTextField.text {
//
//            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                // [START_EXCLUDE]
//
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//            }
//
//        } else {
//            print("email/password can't be empty")
//        }
//    }

}

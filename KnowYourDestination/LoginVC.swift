//
//  LoginVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/12/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var loginView: EmailLoginView!
    @IBOutlet weak var RegisterView: RegisterView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
//        changeLoginView()
        
//        loginRegisterSwitch.addTarget(self, action: #selector(self.changeLoginView), for: .valueChanged)
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
        
        var initialViewController: UIViewController = UIStoryboard.initialViewController(for: .main)
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let userUid = user?.uid else {return}
                
//                DispatchQueue.global(qos: .background).async {
//                    
//                }
                UserService.show(forUID: userUid, completion: { (user) in
                    
                    guard let user = user else {return}
                    
                    User.setCurrent(user: user, userUid, isTourGuide: user.isTourGuide, username: user.username, writeToUserDefaults: true)
                    
                    if user.isTourGuide{
                        initialViewController = UIStoryboard.initialViewController(for: .guide)
                    } else {
                        initialViewController = UIStoryboard.initialViewController(for: .main)
                    }
                    
                    self.view.window?.rootViewController = initialViewController
                    // 4
                    self.view.window?.makeKeyAndVisible()

                })
                
                
                
                
            }
            
        } else {
            print("email/password can't be empty")
        }
    }


    
}

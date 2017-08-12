//
//  LoginVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/12/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase
import Gifu

class LoginVC: UIViewController {

//    @IBOutlet weak var loginView: EmailLoginView!
//    @IBOutlet weak var RegisterView: RegisterView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var gifImage: GIFImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    var currentGIFName: String = "loginGif" {
        didSet {
            gifImage.animate(withGIFNamed: currentGIFName)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = 3
        passwordTextField.layer.cornerRadius = 3
        registerButton.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        gifImage.startAnimatingGIF()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gifImage.prepareForReuse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gifImage.animate(withGIFNamed: currentGIFName)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        
        var initialViewController: UIViewController = UIStoryboard.initialViewController(for: .main)
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let userUid = user?.uid else {return}
                
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        if segue.identifier == "Register" {
            let vc = segue.destination as! RegisterVC
            
            vc.email = email
            vc.password = password
        }
        
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Register", sender: self.registerButton)
    }
    
}

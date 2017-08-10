//
//  RegisterViewController.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/16/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import Gifu

class RegisterVC: UIViewController {
    
    var email: String = ""
    var password = ""

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var travelGuideSwitch: UISwitch!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var gifImage: GIFImageView!
    
    @IBOutlet weak var registerButton: UIButton!
    var currentGIFName: String = "registerGif" {
        didSet {
            gifImage.animate(withGIFNamed: currentGIFName)
        }
    }
    
    let locationManager = CLLocationManager()
    var addressString = ""
    var currentCity: String = ""
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.TWBlue
        
        emailTextField.layer.cornerRadius = 3
        passwordTextField.layer.cornerRadius = 3
        usernameTextField.layer.cornerRadius = 3
        cityTextField.layer.cornerRadius = 3
        registerButton.layer.cornerRadius = 3
        
        travelGuideSwitch.isOn = false
        gifImage.startAnimatingGIF()
        
        emailTextField.text = email
        passwordTextField.text = password
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }

        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gifImage.prepareForReuse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gifImage.animate(withGIFNamed: currentGIFName)
    }

    
    @IBAction func toggleTourGuide(_ sender: UISwitch) {
        if cityTextField.text == "" {
            if self.travelGuideSwitch.isOn {
                let cityAlert = UIAlertController(title: "Is \(self.addressString) your city?", message: "", preferredStyle: .actionSheet)
                cityAlert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                    self.cityTextField.text = self.addressString
                })
                cityAlert.addAction(UIAlertAction(title: "No", style: .cancel) { action in
                    let inputCityAction = UIAlertController(title: "Which city will you be a local guide for?", message: "", preferredStyle: .alert)
                    
                    inputCityAction.addTextField(configurationHandler: nil)
                    
                    inputCityAction.addAction(UIAlertAction(title: "Save City", style: .default) { action in
                        guard let city = inputCityAction.textFields?[0].text else {return}
                        
                        self.cityTextField.text = city
                    })
                    
                    inputCityAction.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    
                    self.present(inputCityAction, animated: true, completion: nil)
                    
                    self.cityTextField.isHidden = false
                    
                })
                
                self.present(cityAlert, animated: true)
            }
            
        }
        if self.travelGuideSwitch.isOn {
            self.cityTextField.isHidden = false
        } else {
            self.cityTextField.isHidden = true
        }
        
    }

    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text
            else {return}
        
        if email == "" || password == "" || username == "" {
            let alert = UIAlertController(title: "Empty Fields", message: "Please fill all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismis", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        guard let city = self.cityTextField.text
            else {return}
        if self.travelGuideSwitch.isOn {
            if city == "" {
                let cityAlert = UIAlertController(title: "What's your city?", message: "You need to sepcify a city to be a tour guide", preferredStyle: .alert)
                cityAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(cityAlert, animated: true, completion: nil)
                return
            }
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
//                assertionFailure(error.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Dismis", style: .default))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            guard let user = user
                else { return }
            
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            
            // 3
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? [String : Any] {
                    let alert = UIAlertController(title: "User Taken", message: "A user with this email already exists", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismis", style: .default) { action in
                        
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    UserService.create(user, username: username, isTourGuide: self.travelGuideSwitch.isOn, completion: { (user) in
                        guard let user = user else { return }
                        User.setCurrent(user: user, user.uid, isTourGuide: user.isTourGuide, username: username, writeToUserDefaults: true)
                        
                        var storyboard: UIStoryboard
                        if self.travelGuideSwitch.isOn {
                            
                            storyboard = UIStoryboard(name: "Guide", bundle: .main)
                            TourGuideService.create(uid: user.uid, city: city, completion: { (tourGuide) in
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
}


extension RegisterVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
        displayLocation(coordinate: currentLocation!)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func displayLocation(coordinate: CLLocation){
        CLGeocoder().reverseGeocodeLocation(coordinate) { (placemarks, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                guard let currentLocation = placemarks?.first else {
                    return
                }
                self.addressString = currentLocation.subAdministrativeArea!
            }
        }
    }
}

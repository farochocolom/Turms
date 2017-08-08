//
//  CreateCityPostVC.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/18/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Firebase

class CreateCityPostVC: UIViewController {

    @IBOutlet weak var postTextField: UITextView!
    
    @IBOutlet weak var postImagePicker: UIImageView!
    @IBOutlet weak var interactionTagButton: UIButton!
    @IBOutlet weak var foodTagButton: UIButton!
    @IBOutlet weak var peopleTagButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var takePictureButton: UIButton!
    
    @IBOutlet weak var imageHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var removePictureButton: UIButton!
    
    var img = UIImageView()
    var tagsArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        postTextField.placeholder = "Tell us about your city"
        postImagePicker.isHidden = true
        removePictureButton.isHidden = true
        
        interactionTagButton.isSelected = true
        interactionTagButton.backgroundColor = UIColor.TWPurple
        interactionTagButton.tintColor = UIColor.clear
        foodTagButton.isSelected = false
        peopleTagButton.isSelected = false
        
        interactionTagButton.layer.cornerRadius = interactionTagButton.layer.bounds.height / 2
        foodTagButton.layer.cornerRadius = foodTagButton.layer.bounds.height / 2
        peopleTagButton.layer.cornerRadius = peopleTagButton.layer.bounds.height / 2
        
        addImageButton.imageView?.contentMode = .scaleAspectFill
        addImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPostImageView)))
        takePictureButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTakePostImageView)))
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    @IBAction func interactionBtnPressed(_ sender: UIButton) {
        
        if !interactionTagButton.isSelected {
            interactionTagButton.backgroundColor = UIColor.TWPurple
            interactionTagButton.tintColor = UIColor.clear
            interactionTagButton.isSelected = true
            
        } else {
            interactionTagButton.backgroundColor = UIColor.TWBlue
            interactionTagButton.tintColor = UIColor.clear
            interactionTagButton.isSelected = false
        }

    }
    
    @IBAction func peopleBtnPressed(_ sender: UIButton) {
        if !peopleTagButton.isSelected {
            peopleTagButton.backgroundColor = UIColor.TWPurple
            peopleTagButton.tintColor = UIColor.clear
            peopleTagButton.isSelected = true
            
        } else {
            peopleTagButton.backgroundColor = UIColor.TWBlue
            peopleTagButton.tintColor = UIColor.clear
            peopleTagButton.isSelected = false
        }

    }
    
    @IBAction func foodBtnPressed(_ sender: UIButton) {
        if !foodTagButton.isSelected {
            foodTagButton.backgroundColor = UIColor.TWPurple
            foodTagButton.tintColor = UIColor.clear
            foodTagButton.isSelected = true
            
        } else {
            foodTagButton.backgroundColor = UIColor.TWBlue
            foodTagButton.tintColor = UIColor.clear
            foodTagButton.isSelected = false
        }
    }
    
    
    @IBAction func savePostBtnPRessed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        guard let postText = postTextField.text,
            let interaction = interactionTagButton.currentTitle,
            let image = postImagePicker.image,
            let food = foodTagButton.currentTitle,
            let people = peopleTagButton.currentTitle,
            let currentUserUID = Auth.auth().currentUser?.uid,
            let username = defaults.object(forKey: Constants.UserDef.username) as? String
            else {return}
        
        if interactionTagButton.isSelected {
            self.tagsArr.append(interaction)
        }
        
        if foodTagButton.isSelected {
            self.tagsArr.append(food)
        }
        
        if peopleTagButton.isSelected {
            self.tagsArr.append(people)
        }
        
        if !peopleTagButton.isSelected && !foodTagButton.isSelected && !interactionTagButton.isSelected {
            let alert = UIAlertController(title: "No tag selected", message: "Please select one tag to identify the type of the post", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismis", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if postText == "" {
            let alert = UIAlertController(title: "No post description", message: "Please enter a description in the post's text area", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismis", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        CityPostService.create(for: image, postedBy: currentUserUID, postedByName: username, postText: postText, tags: self.tagsArr, city: "Los Angeles", completion: { (finished) in
            if finished {
                self.dismiss(animated: true, completion: nil)
            }
        })

    }
    
    @IBAction func removePictureButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Remove Image", message: "Are you sure you want to remove the image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .default){ alert in
            UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseInOut],
                           animations: {
                            
                self.postImagePicker.isHidden = true
                self.removePictureButton.isHidden = true
                self.postImagePicker.image = UIImage(named: "image")
                self.imageHeightContraint.constant = 15
                            
            }, completion: nil)

            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

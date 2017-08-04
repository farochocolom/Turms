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
    
    var img = UIImageView()
    var tagsArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
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
        
        
        CityPostService.create(for: image, postedBy: currentUserUID, postedByName: username, postText: postText, tags: self.tagsArr, completion: { (finished) in
            if finished {
                self.dismiss(animated: true, completion: nil)
            }
        })

    }

}

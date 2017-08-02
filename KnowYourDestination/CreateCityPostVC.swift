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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        interactionTagButton.isSelected = false
        foodTagButton.isSelected = false
        peopleTagButton.isSelected = false
        
        if !interactionTagButton.isSelected {
            interactionTagButton.backgroundColor = UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 1.0)
            interactionTagButton.setTitleColor(UIColor.blue, for: .selected)
        }
        
        addImageButton.imageView?.contentMode = .scaleAspectFill
        addImageButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPostImageView)))
        takePictureButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTakePostImageView)))
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
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
        
        CityPostService.create(for: image, postedBy: currentUserUID, postedByName: username, postText: postText, tags: [food,people], completion: { (finished) in
            
            if finished {
                self.performSegue(withIdentifier: "createPost", sender: nil)
            }
            
        })

    }

}

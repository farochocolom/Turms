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
    
    var img = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        postImagePicker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPostImageView)))
        
        postImagePicker.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let postText = postTextField.text,
            let interaction = interactionTagButton.currentTitle,
            let image = postImagePicker.image,
            let food = foodTagButton.currentTitle,
            let people = peopleTagButton.currentTitle,
            let currentUserUID = Auth.auth().currentUser?.uid
        else {return}
        
        CityPostService.create(for: image, postedBy: currentUserUID, postText: postText, tags: [food,people])
        
    }

}

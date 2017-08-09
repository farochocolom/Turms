//
//  CreateCityPostVC+handlers.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/19/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit


extension CreateCityPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func handleSelectPostImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func handleTakePostImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let selected = selectedImage {
            postImagePicker.image = selected
        }
        
        dismiss(animated: false)
        {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.postImagePicker.isHidden = false
                self.imageHeightContraint.constant = 230
                self.removePictureButton.isHidden = false
                
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
}

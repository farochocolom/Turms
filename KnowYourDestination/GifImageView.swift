//
//  GifImageView.swift
//  
//
//  Created by Fernando on 8/9/17.
//
//

import UIKit
import Gifu

class GifImageView: UIImageView, GIFAnimatable {
    public lazy var animator: Animator? = {
        return Animator(withDelegate: self)
    }()
    
    override public func display(_ layer: CALayer) {
        updateImageIfNeeded()
    }
}

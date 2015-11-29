//
//  SplashViewController.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/17/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the BG image
        let backgroundImageView = UIImageView(image: UIImage(named: "Splash_bg"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)

    }
    
}


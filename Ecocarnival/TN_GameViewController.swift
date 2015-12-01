//
//  GameViewController.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/9/15.
//  Copyright (c) 2015 amliu. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit


class TN_GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace the main view with our game scene
        let scene = TN_GameScene(fileNamed: "TN_GameScene.sks")
        scene!.scaleMode = .ResizeFill
        scene?.viewController = self
        
        let skView = self.view as! SKView
        skView.presentScene(scene)

    }
    
    override func viewWillLayoutSubviews() {
        // Called whenever a new view is added
        super.viewWillLayoutSubviews()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

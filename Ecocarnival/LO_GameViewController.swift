//
//  LO_GameViewController.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/7/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit
import SpriteKit


class LO_GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace the main view with our game scene
        let scene = LO_GameScene(fileNamed: "LO_GameScene.sks")
        scene!.scaleMode = .ResizeFill
        scene?.viewController = self
        
        let skView = self.view as! SKView
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

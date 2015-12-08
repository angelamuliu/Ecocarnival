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
    
    var gameScene:TN_GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gameScene == nil {
            // Replace the main view with our game scene
            gameScene = TN_GameScene(fileNamed: "TN_GameScene.sks")
            gameScene?.scaleMode = .ResizeFill
            gameScene?.viewController = self
        }
        
        let skView = self.view as! SKView
        skView.presentScene(gameScene)
    }
    
    override func viewWillLayoutSubviews() {
        // Called whenever a new view is added
        super.viewWillLayoutSubviews()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidDisappear(animated: Bool) {
        let skView = self.view as! SKView
        skView.presentScene(nil)
        self.gameScene = nil // Deallocate to remove scene from memory to prevent leak
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

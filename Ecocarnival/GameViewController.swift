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


class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//         let scene = TN_GameScene(fileNamed: "TN_GameScene.sks")
//        scene!.scaleMode = .AspectFill
//        
//        let skView = self.view as! SKView
////        skView.showsFPS = true
////        skView.showsNodeCount = true
//        
//        skView.presentScene(scene)
    }
    
    override func viewWillLayoutSubviews() {
        let scene = TN_GameScene(fileNamed: "TN_GameScene.sks")
        scene!.scaleMode = .ResizeFill
        
        let skView = self.view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount = true
        
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

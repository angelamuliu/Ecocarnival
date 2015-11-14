//
//  GameScene.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/9/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit


// http://spin.atomicobject.com/2014/12/29/spritekit-physics-tutorial-swift/
// http://www.raywenderlich.com/84341/create-breakout-game-sprite-kit-swift
// http://stackoverflow.com/questions/28245653/how-to-throw-skspritenode

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isTouchingTrash = false
    var touchPoint:CGPoint = CGPoint()
    var trashNode:TrashNode = TrashNode.trash(CGPoint(x: 550, y: 550))
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.addChild(trashNode)
        
        let trashbinNode:BinNode = BinNode.trashbin(CGPoint(x: 0, y: 300))
        self.addChild(trashbinNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            if let body = physicsWorld.bodyAtPoint(touchLocation) {
                if body.node!.name == "Trash" {
                    isTouchingTrash = true
                    touchPoint = touchLocation
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isTouchingTrash {
            let touch = touches.first! as UITouch
            let touchLocation = touch.locationInNode(self)
            touchPoint = touchLocation
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouchingTrash = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        if isTouchingTrash {
            let dt:CGFloat = 1.0/30.0
            let distance = CGVector(dx: touchPoint.x-trashNode.position.x, dy: touchPoint.y-trashNode.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            trashNode.physicsBody!.velocity=velocity
        }
    }
    
    
    // http://stackoverflow.com/questions/26438108/ios-swift-didbegincontact-not-being-called
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("CONTACT")
//        SKPhysicsBody *firstBody, *secondBody;
//        
//        firstBody = contact.bodyA;
//        secondBody = contact.bodyB;
//        
//        if(firstBody.categoryBitMask == spikeHitCategory || secondBody.categoryBitMask == spikeHitCategory)
//        {
//            
//            NSLog(@"balloon hit the spikes");
//            //setup your methods and other things here
//            
//        }
    }
    
    
    
}


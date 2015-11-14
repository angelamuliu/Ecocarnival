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

class TN_GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game = TN_Model()
    var isTouchingTrash = false
    var touchPoint:CGPoint = CGPoint()
    var trashNode:TrashNode = TrashNode.trash(CGPoint(x: 550, y: 550))
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self // Needed for collision detection
        
        let bgImage = SKSpriteNode(imageNamed: "TN_bg.png") // Load BG
        bgImage.zPosition = 1
        bgImage.setScale(2)
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(bgImage)
        
        self.addChild(trashNode)
        
        // Setup trash and recycle bins
        let trashbinNode:BinNode = BinNode.trashbin(CGPoint(x: 50, y: self.frame.size.height/2))
        self.addChild(trashbinNode)
        let recyclebinNode:BinNode = BinNode.recyclebin(CGPoint(x: self.frame.size.width-50, y: self.frame.size.height/2))
        self.addChild(recyclebinNode)
        
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
    
    // http://stackoverflow.com/questions/28245653/how-to-throw-skspritenode
    override func update(currentTime: CFTimeInterval) {
        if isTouchingTrash {
            let dt:CGFloat = 1.0/12.0
            let distance = CGVector(dx: touchPoint.x-trashNode.position.x, dy: touchPoint.y-trashNode.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            trashNode.physicsBody!.velocity=velocity
        }
    }
    
    
    // http://stackoverflow.com/questions/26438108/ios-swift-didbegincontact-not-being-called
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
//        firstBody.node!.name ==
        
        if (firstBody.categoryBitMask == TrashNode.trashHitCategory || secondBody.categoryBitMask == BinNode.binHitCategory) {
            print("CONTACT")
        }
    }
    
    
    
}


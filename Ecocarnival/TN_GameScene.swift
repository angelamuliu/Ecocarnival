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
    
    // UI
    var scoreLabel = SKLabelNode()
    var lifeNodes = [SKSpriteNode]()
    
    // Game Interaction
    var isTouchingTrash = false
    var touchPoint:CGPoint = CGPoint()
    var touchedTrash:SKNode? // The trashnode currently being interacted with
    
    
//    var trashNode:TrashNode = TrashNode.trash(CGPoint(x: 550, y: 220))
    var trashNode2:TrashNode = TrashNode.recyclable(CGPoint(x: 570, y: 250))
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self // Needed for collision detection
        
        // Load BG
//        let bgImage = SKSpriteNode(imageNamed: "TN_bg.png")
//        bgImage.zPosition = 1
//        bgImage.setScale(2)
//        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
//        self.addChild(bgImage)
        
        // Load UI
        scoreLabel = UI_Components.createScoreLabel(String(game.score), position: CGPoint(x: self.size.width, y: self.size.height))
        self.addChild(scoreLabel)
        lifeNodes = UI_Components.createLifeNodes(5, startPosition: CGPoint(x:0, y:self.size.height))
        for lifeNode in lifeNodes {
            self.addChild(lifeNode)
        }

        
//        self.addChild(trashNode)
        self.addChild(trashNode2)
        
        // Setup trash and recycle bins
        let trashbinNode:BinNode = BinNode.trashbin(CGPoint(x: 50, y: self.frame.size.height/2))
        self.addChild(trashbinNode)
        let recyclebinNode:BinNode = BinNode.recyclebin(CGPoint(x: self.frame.size.width-50, y: self.frame.size.height/2))
        self.addChild(recyclebinNode)
        
        // Setup the offscreen 'misc' bin
//        let miscbinNode:BinNode = BinNode.miscbin(CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), width: self.frame.size.width)
//        self.addChild(miscbinNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let nodeAtPoint = self.nodeAtPoint(touchLocation)
            print(touchLocation)
            if nodeAtPoint is TrashNode {
                isTouchingTrash = true
                touchPoint = touchLocation
                touchedTrash = nodeAtPoint
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
        touchedTrash = nil
    }
    
    // http://stackoverflow.com/questions/28245653/how-to-throw-skspritenode
    override func update(currentTime: CFTimeInterval) {
        if isTouchingTrash {
            let dt:CGFloat = 1.0/12.0
            let distance = CGVector(dx: touchPoint.x-touchedTrash!.position.x, dy: touchPoint.y-touchedTrash!.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            touchedTrash!.physicsBody!.velocity=velocity
        }
    }
    
    
    // http://stackoverflow.com/questions/26438108/ios-swift-didbegincontact-not-being-called
    func didBeginContact(contact: SKPhysicsContact) {        
        let firstCategory = contact.bodyA.categoryBitMask
        let secondCategory = contact.bodyB.categoryBitMask
        
        if (firstCategory != Constants.noCollisionCategory && secondCategory != Constants.noCollisionCategory) {
            // Did a trash node hit a trash can? Doing checks for all proper matches
            if (TN_Model.checkMatchingBin(firstCategory, secondCategory: secondCategory)) {
                game.increaseScore()
                scoreLabel.text = String(game.score)
            } else { // Looks like the trash went into the wrong bin
                game.decreaseLife()
                print(game.life)
                UI_Components.updateLifeNodes(game.life, lifeNodes: lifeNodes)
            }
            if let trashNode = TN_Model.getTrashNodeFromBody(contact.bodyA, secondBody: contact.bodyB) {
                trashNode.removeFromParent()
                self.addChild(TrashNode.generateRandomTrash(CGPoint(x: 500, y: 250)))
            }
        }
    }
    
    
    
}


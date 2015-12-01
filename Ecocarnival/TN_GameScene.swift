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
    var modalView:UIView? // The modal that appears on game over
    
    // Game Interaction
    var isTouchingTrash = false
    var touchPoint:CGPoint = CGPoint()
    var touchedTrash:SKNode? // The trashnode currently being interacted with
    
    // TN_GameViewController
    var viewController:UIViewController?
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self // Needed for collision detection
        
        // Load BG
        let bgImage = SKSpriteNode(imageNamed: "TN_bg.png")
        bgImage.zPosition = 1
        bgImage.setScale(2)
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(bgImage)
        
        // Load UI
        scoreLabel = UI_Components.createScoreLabel(String(game.score), position: CGPoint(x: self.size.width, y: self.size.height))
        self.addChild(scoreLabel)
        lifeNodes = UI_Components.createLifeNodes(5, startPosition: CGPoint(x:0, y:self.size.height))
        for lifeNode in lifeNodes {
            self.addChild(lifeNode)
        }
        
        // Setup trash and recycle bins
        let trashbinNode:BinNode = BinNode.trashbin(CGPoint(x: 0, y: self.frame.size.height/2))
        self.addChild(trashbinNode)
        let recyclebinNode:BinNode = BinNode.recyclebin(CGPoint(x: self.frame.size.width, y: self.frame.size.height/2))
        self.addChild(recyclebinNode)
        
        // Setup the 'misc' bin which catches anything that tumbles offscreen
        let miscbinNode:BinNode = BinNode.miscbin(CGPoint(x: self.frame.size.width/2, y: -400.0), width: self.frame.size.width * 3)
        self.addChild(miscbinNode)
        
        // Toss up the first trash
//        addNewTrash()
        
        // TEMP
        gameOverDialog()
        
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
    
    // didBeginContact is called multiple times but we only want to update once per trash + bin collision
    var updatesCalled = 0
    
    // http://stackoverflow.com/questions/28245653/how-to-throw-skspritenode
    override func update(currentTime: CFTimeInterval) {
        if isTouchingTrash {
            let dt:CGFloat = 1.0/12.0
            let distance = CGVector(dx: touchPoint.x-touchedTrash!.position.x, dy: touchPoint.y-touchedTrash!.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            touchedTrash!.physicsBody!.velocity=velocity
        }
        updatesCalled++
    }
    
    
    // http://stackoverflow.com/questions/26438108/ios-swift-didbegincontact-not-being-called
    func didBeginContact(contact: SKPhysicsContact) {        
        let firstCategory = contact.bodyA.categoryBitMask
        let secondCategory = contact.bodyB.categoryBitMask
        
        if (firstCategory != Constants.noCollisionCategory && secondCategory != Constants.noCollisionCategory && updatesCalled != 0) {
            // Did a trash node hit a trash can? Doing checks for all proper matches
            if (TN_Model.checkMatchingBin(firstCategory, secondCategory: secondCategory)) {
                game.increaseScore()
                scoreLabel.text = String(game.score)
            } else { // Looks like the trash went into the wrong bin
                game.decreaseLife()
                UI_Components.updateLifeNodes(game.life, lifeNodes: lifeNodes)
            }
            if let trashNode = TN_Model.getTrashNodeFromBody(contact.bodyA, secondBody: contact.bodyB) {
                trashNode.removeFromParent()
                
                if (game.isGameOver) {
                    self.scene!.paused = true
                    gameOverDialog()
                } else {
                    addNewTrash()
                }
                
            }
            updatesCalled = 0
        }
    }
    
    func addNewTrash() {
        let newTrash = TrashNode.generateRandomTrash(CGPoint(x: self.frame.size.width/2, y: -50))
        self.addChild(newTrash)
        tossTrash(newTrash)
    }
    
    // Applies an impulse to a trash node to 'toss' it up to the air
    func tossTrash(trash: SKNode) {
        let upwardVelocity = CGVector(dx: 0.0, dy: 550.0 + Double(arc4random_uniform(120)))
        trash.physicsBody!.applyImpulse(upwardVelocity)
        
        // You make me spin right round baby right round
        let spinForce = 0.15 + (CGFloat(arc4random_uniform(50))/100.0)
        trash.physicsBody!.applyAngularImpulse(spinForce)
    }
    
    // Slides the modal view back out and resets the game
    func resetGame(sender:UIButton!) {
        UIView.animateWithDuration(0.3,
            animations: { void in
                self.modalView!.frame = CGRect(x: 0, y: self.size.height, width: self.size.width, height: self.size.height)
                self.modalView!.layer.opacity = 0.0
            },
            completion: { finished in
                self.modalView!.removeFromSuperview()
                self.game.resetGame()
                // TODO : Update score label
                UI_Components.updateLifeNodes(self.game.life, lifeNodes: self.lifeNodes)
                
                self.scene!.paused = false
                self.addNewTrash()
        })
    }
    
    func backToHome(sender:UIButton!) {
        self.viewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Shows the game over UI component and also animates it sliding up
    func gameOverDialog() {
        if modalView == nil { // Initalize if not yet already
            modalView = UI_Components.createDialog(self, text: "Game over!\nYour score")
            createButtons(modalView!)
        }
        self.view!.addSubview(modalView!)
        UIView.animateWithDuration(0.3,
            animations: { void in
                self.modalView!.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
                self.modalView!.layer.opacity = 1.0
            },
            completion: { finished in
                self.modalView!.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        })
    }
    
    // Janky, but we add buttons to a UIView dialog that connect to game logic
    func createButtons(modalView: UIView) {
        let restartButton = UIButton(frame: CGRect(x: modalView.frame.width/4, y: 180, width: modalView.frame.width/5, height: 40))
        restartButton.layer.cornerRadius = 4.0
        restartButton.setTitle("Replay", forState: UIControlState.Normal)
        restartButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        restartButton.backgroundColor = Constants.orangeColor
        restartButton.layer.borderWidth = 3
        restartButton.layer.borderColor = Constants.bloodOrangeColor.CGColor
        restartButton.addTarget(self, action: "resetGame:", forControlEvents: .TouchUpInside)
        
        let homeButton = UIButton(frame: CGRect(x: (modalView.frame.width/4)*3 - modalView.frame.width/5, y: 180, width: modalView.frame.width/5, height: 40))
        homeButton.layer.cornerRadius = 4.0
        homeButton.setTitle("Quit", forState: UIControlState.Normal)
        homeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeButton.backgroundColor = Constants.lightGreyColor
        homeButton.layer.borderWidth = 3
        homeButton.layer.borderColor = Constants.greyColor.CGColor
        homeButton.addTarget(self, action: "backToHome:", forControlEvents: .TouchUpInside)
        
        
        modalView.addSubview(restartButton)
        modalView.addSubview(homeButton)
    }
    
    
}


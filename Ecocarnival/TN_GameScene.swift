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
import AVFoundation

// These tutorials really helped me get started : )
// http://spin.atomicobject.com/2014/12/29/spritekit-physics-tutorial-swift/
// http://www.raywenderlich.com/84341/create-breakout-game-sprite-kit-swift

/**
 Trash ninja game scene
*/
class TN_GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game = TN_Model()
    
    // UI
    var scoreNodes = [SKSpriteNode]()
    var lifeNodes = [SKSpriteNode]()
    
    var modalView:Dialog_UIView?

    // Game Interaction
    var isTouching = false
    var touchPoint:CGPoint = CGPoint()
    var touchedThrowable:SKNode? // The node currently being touched
    
    var lastSpawnTime = CFTimeInterval()
    
    var viewController:UIViewController? // TN_GameViewController
    
    // Preloading SFX
    let sfx_hitTrash1 = SKAction.playSoundFileNamed("hitTrash1.aiff", waitForCompletion: false)
    
    // Music
    var backgroundMusic : AVAudioPlayer?
    
    override func didMoveToView(view: SKView) {
        
        
        if let backgroundMusic = UI_Components.setupAudioPlayerWithFile("Jaunty Gumption", type: "mp3") {
            self.backgroundMusic = backgroundMusic
            self.backgroundMusic?.volume = 0.3
            self.backgroundMusic?.play()
        }
        
        
        
        
        
        self.physicsWorld.contactDelegate = self // Needed for collision detection
        
        // Load BG
        let bgImage = SKSpriteNode(imageNamed: "TN_bg.png")
        bgImage.zPosition = 1
        bgImage.setScale(2)
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(bgImage)
        
        // Load score UI
        self.scoreNodes = UI_Components.createScoreNodes(game.score, topRightCorner: CGPoint(x:self.size.width, y: self.size.height))
        self.attachScoreToSKScene()
        self.addChild(UI_Components.createScoreLabel(CGPoint(x: self.size.width, y: self.size.height - 6 - scoreNodes[0].size.height)))
        
        // Load Life UI
        lifeNodes = UI_Components.createLifeNodes(5, startPosition: CGPoint(x:0, y:self.size.height))
        for lifeNode in lifeNodes {
            self.addChild(lifeNode)
        }
        
        // Load the reusable modal frame
        modalView = Dialog_UIView(gameScene: self, text: "Game over!\nFinal score")
        
        // Setup trash and recycle bins
        let trashbinNode:BinNode = BinNode.trashbin(CGPoint(x: 0, y: self.frame.size.height/2))
        self.addChild(trashbinNode)
        let recyclebinNode:BinNode = BinNode.recyclebin(CGPoint(x: self.frame.size.width, y: self.frame.size.height/2))
        self.addChild(recyclebinNode)
        
        // Setup the 'misc' bin which catches anything that tumbles offscreen
        let miscbinNode:BinNode = BinNode.miscbin(CGPoint(x: self.frame.size.width/2, y: -400.0), width: self.frame.size.width * 3)
        self.addChild(miscbinNode)
        
        // Load BG music
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let nodeAtPoint = self.nodeAtPoint(touchLocation)
            print(touchLocation)
            if nodeAtPoint is Throwable {
                isTouching = true
                touchPoint = touchLocation
                touchedThrowable = nodeAtPoint
            }
            dealWithPowerups(nodeAtPoint)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isTouching {
            let touch = touches.first! as UITouch
            let touchLocation = touch.locationInNode(self)
            touchPoint = touchLocation
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching = false
        touchedThrowable = nil
    }
    
    // didBeginContact is called multiple times but we only want to update once per trash + bin collision
    var updatesCalled = 0
    
    // http://stackoverflow.com/questions/28245653/how-to-throw-skspritenode
    override func update(currentTime: CFTimeInterval) {
        let timeSinceLastSpawn = currentTime - lastSpawnTime
        if timeSinceLastSpawn > game.spawnRate {
            lastSpawnTime = currentTime
            addNewThrowable()
        }
    
        if isTouching {
            let dt:CGFloat = 1.0/12.0
            let distance = CGVector(dx: touchPoint.x-touchedThrowable!.position.x, dy: touchPoint.y-touchedThrowable!.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            touchedThrowable!.physicsBody!.velocity=velocity
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
                increaseScore()
                if !game.isMaxLevel && game.score >= game.toNextLevel {
                    game.increaseLevel()
                    nextLevelDialog()
                }
            } else { // Looks like the trash went into the wrong bin
                game.decreaseLife()
                UI_Components.updateLifeNodes(game.life, lifeNodes: lifeNodes)
            }
            self.runAction(sfx_hitTrash1) // Playing a SFX
            if let throwable = TN_Model.getThrowableFromBody(contact.bodyA, secondBody: contact.bodyB) {
                throwable.removeFromParent()
                if (game.isGameOver) {
                    gameOverDialog()
                }
            }
            updatesCalled = 0
        }
    }
    
    func addNewThrowable() {
        let newTrash = game.generateRandomTrash(CGPoint(x: self.frame.size.width/2, y: -50))
        self.addChild(newTrash)
        if (newTrash.name! == Constants.powerup) {
            tossTrash(newTrash) // Powerups have particle effects which have visual bugs when spun
        } else {
            spinTossTrash(newTrash)
        }
    }
    
    func spinTossTrash(trash: SKNode) {
        tossTrash(trash)
        spinTrash(trash)
    }
    
    // Applies an impulse to a trash node to 'toss' it up to the air
    func tossTrash(trash: SKNode) {
        let upwardVelocity = CGVector(dx: 0.0, dy: 550.0 + Double(arc4random_uniform(120)))
        trash.physicsBody!.applyImpulse(upwardVelocity)
    }
    
    // You make me spin right round baby right round
    func spinTrash(trash: SKNode) {
        let spinForce = 0.15 + (CGFloat(arc4random_uniform(50))/100.0)
        trash.physicsBody!.applyAngularImpulse(spinForce)
    }
    
    // Increases score in our model and updates any necessay sprites on the UI
    func increaseScore() {
        game.increaseScore()
        let prevScoreNodes = scoreNodes.count
        UI_Components.updateScoreNodes(game.score, scoreNodes: &scoreNodes)
        if (prevScoreNodes < scoreNodes.count) { // Went up a tens place, need to attach new scoreNodes sprites
            let diff = scoreNodes.count - prevScoreNodes
            for (var i = 0; i < diff; i++) {
                self.addChild(scoreNodes[i])
            }
        }
    }

    func dealWithPowerups(nodeAtPoint: SKNode) {
        if let nodeName = nodeAtPoint.name {
            if nodeName == Constants.powerup {
                game.increaseLife()
                UI_Components.updateLifeNodes(game.life, lifeNodes: lifeNodes)
                
                let powerupNode = nodeAtPoint is SKEmitterNode ? nodeAtPoint.parent! : nodeAtPoint
                powerupNode.physicsBody!.affectedByGravity = false
                let actionSequence = SKAction.sequence([SKAction.scaleBy(1.5, duration: 0.3), SKAction.fadeAlphaTo(0.0, duration: 0.2)])
                powerupNode.runAction(actionSequence, completion: {
                    powerupNode.removeFromParent()
                })
            }
        }
    }
    
    // Given sprite nodes representing score, attaches them to a SK scene
    func attachScoreToSKScene() {
        for scoreNode in self.scoreNodes {
            self.addChild(scoreNode)
        }
    }
    
    
    // -------------------------------------------------------
    // Dialog UI View
    
    // Shows the game over UI component and also animates it sliding up
    func gameOverDialog() {
        self.scene!.paused = true
        
        // Clear any possible unnecessary elements from the modal
        self.modalView!.removeNewTrashDisplay()
        self.modalView!.removeContinueButton()
        
        self.modalView!.resetText("Game over!\nFinal score")
        createButtons(modalView!)
        self.modalView!.addScore(self.game.score)
        
        self.view!.addSubview(modalView!)
        self.modalView!.slideUpDialog()
    }
    
    // Slides the modal view back out and resets the game
    func resetGame(sender:UIButton!) {
        self.modalView!.slideDownDialog({ finished in
            self.modalView!.removeFromSuperview()
            self.game.resetGame()
            
            for scoreNode in self.scoreNodes { // Reset the score UI
                scoreNode.removeFromParent()
            }
            self.scoreNodes = UI_Components.createScoreNodes(self.game.score, topRightCorner: CGPoint(x:self.size.width, y: self.size.height))
            self.attachScoreToSKScene()
            
            UI_Components.updateLifeNodes(self.game.life, lifeNodes: self.lifeNodes)
                            
            self.scene!.paused = false
        })
    }
    
    func backToHome(sender:UIButton!) {
        self.viewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Connecting up the restart and home buttons in the dialog UIView to game logic
    func createButtons(modalView: UIView) {
        if let dialog = self.modalView {
            dialog.addRestartButton()
            dialog.restartButton!.addTarget(self, action: "resetGame:", forControlEvents: .TouchUpInside)
            dialog.addBackToHomeButton()
            dialog.homeButton!.addTarget(self, action: "backToHome:", forControlEvents: .TouchUpInside)
        }
    }
    
    // Shows the next level dialog
    func nextLevelDialog() {
        self.scene!.paused = true
        
        // Clear any possible unnecessary elements from the modal
        self.modalView!.removeBackToHomeButton()
        self.modalView!.removeRestartButton()
        self.modalView!.removeScore()
        
        self.modalView!.resetText("Let's step it up!\nNext level we're adding...")
        let newAsset = self.game.addNewThrowable()
        self.modalView!.newTrashDisplay(newAsset["imageNamed"]!, desc: newAsset["desc"]!)
        connectContinueButton()
        
        self.view!.addSubview(modalView!)
        self.modalView!.slideUpDialog()
    }
    
    // Simply unpauses the game and dismisses the modal view
    func unpauseGame(sender:UIButton) {
        self.modalView!.slideDownDialog({ finished in
            self.modalView!.removeFromSuperview()
            self.scene!.paused = false
        })
    }
    
    func connectContinueButton() {
        if let dialog = self.modalView {
            self.modalView!.addContinueButton()
            dialog.continueButtom!.addTarget(self, action: "unpauseGame:", forControlEvents: .TouchUpInside)
        }
    }
    
    
    
    
    
}







//
//  UI_Components.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/16/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

class UI_Components:NSObject {
    
    /**
     Initializes a top right aligned score label given a string to start with and a position as an 'anchor'
    */
    class func createScoreLabel(startingScore:String, position:CGPoint) -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.text = String(startingScore)
        scoreLabel.zPosition = Constants.zUI
        scoreLabel.setScale(2)
        scoreLabel.position = position
        scoreLabel.verticalAlignmentMode = .Top // Our position should be the top right point of the text
        scoreLabel.horizontalAlignmentMode = .Right
        return scoreLabel
    }
    
    /**
     Initializes the life bar, which is a bunch of the life images next to each other. Returns array of said spritenodes
    */
    class func createLifeNodes(startingLife:Int, startPosition: CGPoint) -> [SKSpriteNode] {
        var lifeNodes = [SKSpriteNode]()
        let padding = CGFloat(5) // A tiny amount of padding between screen edge and nodes
        for (var i = 0; i < startingLife; i++) {
            let lifeNode = SKSpriteNode(imageNamed: "TN_life")
            lifeNode.zPosition = Constants.zUI
            lifeNode.position = (CGPoint(x: startPosition.x + padding + (CGFloat(lifeNodes.count) * lifeNode.size.width), y: startPosition.y - padding))
            lifeNode.anchorPoint = CGPointMake(0, 1);
            lifeNodes.append(lifeNode)
        }
        return lifeNodes
    }
    
    /**
     Updates the life bar to match a number that's passed in
    */
    class func updateLifeNodes(lifeCount: Int, lifeNodes:[SKSpriteNode]) {
        let missingLife = lifeNodes.count - lifeCount
        if lifeCount >= 0 {
            for (var i = 0; i < missingLife; i++) {
                lifeNodes[lifeNodes.count - 1 - i].texture = SKTexture(imageNamed:"TN_nolife")
            }
        } else {
            // It's game over lmao
        }
    }
    
    class func createDialog(gameScene: TN_GameScene) -> UIView {
        // A clear UIView covers up the screen but starts offscreen
        let dialog = UIView(frame: CGRect(x: 0, y: gameScene.size.height, width: gameScene.size.width, height: gameScene.size.height))
        dialog.layer.opacity = 0.0
        
        // Contains the dialog
        let wordContainer = UIView(frame: CGRect(x: gameScene.size.width/6, y: 30, width: (gameScene.size.width/6)*4, height: gameScene.size.height / 1.5))
        wordContainer.backgroundColor = UIColor.whiteColor()
        wordContainer.layer.borderWidth = 8;
        
        // Adding light blue gradient color to the word container
        let lightBlue = UIColor(red: 239.0/255.0, green: 251.0/255.0, blue: 255.0 / 255.0, alpha: 1.0).CGColor
        
        // http://stackoverflow.com/questions/23074539/programmatically-create-a-uiview-with-color-gradient
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = CGRect(x: 0, y:0, width: wordContainer.bounds.width, height: wordContainer.bounds.height / 4)
        topGradient.colors = [lightBlue, UIColor.whiteColor().CGColor]
        wordContainer.layer.insertSublayer(topGradient, atIndex: 0)
        
        let botGradient: CAGradientLayer = CAGradientLayer()
        botGradient.frame = CGRect(x: 0, y: (wordContainer.bounds.height/4)*3, width: wordContainer.bounds.width, height: wordContainer.bounds.height / 4)
        botGradient.colors = [UIColor.whiteColor().CGColor, lightBlue]
        wordContainer.layer.insertSublayer(botGradient, atIndex: 0)
        
        let borderColor = UIColor(red: 88.0/255.0, green: 129.0/255.0, blue: 146.0/255.0, alpha: 1.0).CGColor
        wordContainer.layer.borderColor = borderColor
        
        // Drop shadow
        wordContainer.layer.shadowOffset = CGSize(width: 0, height: 7)
        wordContainer.layer.shadowOpacity = 0.5
        wordContainer.layer.shadowRadius = 5.0
        
        dialog.addSubview(wordContainer)
        
        // The cat image goes on top
        let catImage = UIImageView(image: UIImage(named: "Talkcat"))
        catImage.frame = CGRect(x: gameScene.size.width/4, y: (gameScene.size.height/3)*2, width: gameScene.size.width/2, height: gameScene.size.height/3)
        catImage.contentMode = .ScaleAspectFill
        catImage.layer.shadowOpacity = 0.5
        catImage.layer.shadowRadius = 5.0
        
        dialog.addSubview(wordContainer)
        dialog.addSubview(catImage)
        
        return dialog
    }

    
    
}
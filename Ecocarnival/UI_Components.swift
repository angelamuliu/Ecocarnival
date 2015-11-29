//
//  UI_Components.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/16/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

class UI_Components {
    
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
    
    class func createGameOverDialog(screenSize: CGSize) -> UIView {
        let dialog = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width/2, height: screenSize.height/2))
        dialog.backgroundColor = UIColor.whiteColor()
        
        let restartButton = UIButton()
        restartButton.setTitle("TEST", forState: UIControlState.Normal)
        dialog.addSubview(restartButton)
        return dialog
    }
    
    
}
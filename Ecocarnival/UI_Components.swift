//
//  UI_Components.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/16/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class UI_Components:NSObject {
    
    /**
     Creates the score label given a position that servces as its top right corner
    */
    class func createScoreLabel(position:CGPoint) -> SKSpriteNode {
        let scoreLabelSprite = SKSpriteNode(imageNamed: "TN_Score")
        scoreLabelSprite.zPosition = Constants.zUI
        scoreLabelSprite.position = position
        scoreLabelSprite.anchorPoint = CGPoint(x: 1, y: 1)
        return scoreLabelSprite
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
        var missingLife = lifeNodes.count - lifeCount
        if lifeCount >= 0 {
            for (var i = lifeNodes.count - 1; i >= 0; i--) {
                if missingLife > 0 {
                    lifeNodes[i].texture = SKTexture(imageNamed: "TN_nolife")
                    missingLife--
                } else {
                    lifeNodes[i].texture = SKTexture(imageNamed: "TN_life")
                }
            }
        }
    }
    
    /**
     Initializes a score with the handwritten font for SKScenes given some location that acts as the rightmost corner (with vertical centering)
    */
    class func createScoreNodes(score:Int, topRightCorner: CGPoint) -> [SKSpriteNode] {
        var scoreNodes = [SKSpriteNode]()
        let scoreArr = Array(String(score).characters) // We split it e.g. ["1", "0", "2"]

        // Attach the ones place number whose position acts as a reference for all later numbers
        let scoreNode = SKSpriteNode(imageNamed: getScoreNodeNumber(scoreArr[scoreArr.count - 1]))
        scoreNode.zPosition = Constants.zUI
        scoreNode.position = CGPoint(x: topRightCorner.x - scoreNode.size.width, y: topRightCorner.y - 5)
        scoreNode.anchorPoint = CGPoint(x: 0, y: 1)
        scoreNodes.append(scoreNode)
        
        updateScoreNodes(score, scoreNodes: &scoreNodes)
        return scoreNodes
    }

    /**
     Given some score, update and add more score nodes and updates the ones that exist to the new number
    */
    class func updateScoreNodes(score:Int, inout scoreNodes:[SKSpriteNode]) {
        let scoreArr = Array(String(score).characters)
        
        while (scoreArr.count > scoreNodes.count) { // If we go up a tens place
            let prevTopRightCorner = scoreNodes[0].position
            let scoreNode = SKSpriteNode(imageNamed: getScoreNodeNumber(scoreArr[scoreArr.count - scoreNodes.count - 1]))
            scoreNode.zPosition = Constants.zUI
            scoreNode.position = CGPoint(x: prevTopRightCorner.x - scoreNode.size.width, y: prevTopRightCorner.y)
            scoreNode.anchorPoint = CGPoint(x: 0, y: 1)
            scoreNodes.insert(scoreNode, atIndex: 0)
        }
        
        for (var i = 0; i < scoreNodes.count; i++) { // Updating textures to match new number
            scoreNodes[i].texture = SKTexture(imageNamed:getScoreNodeNumber(scoreArr[i]))
        }
    }
    
    /**
     Given a number, returns the corresponding string for the image
    */
    class func getScoreNodeNumber(number:Character) -> String {
        switch number {
            case "0":
                return "TN_0"
            case "1":
                return "TN_1"
            case "2":
                return "TN_2"
            case "3":
                return "TN_3"
            case "4":
                return "TN_4"
            case "5":
                return "TN_5"
            case "6":
                return "TN_6"
            case "7":
                return "TN_7"
            case "8":
                return "TN_8"
            case "9":
                return "TN_9"
            default:
                return "TN_0"
        }
    }


    
    
}
//
//  Model.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/11/15.
//  Copyright © 2015 amliu. All rights reserved.
//


// Trash Ninja Game Logic

import Foundation
import SpriteKit

/**
 Trash ninja game model - Keeps track of score, life, and game state
*/
class TN_Model {
    
    var score = 12101

    var life = 5
    var maxlife = 5
    
    func increaseScore() {
        score++
    }
    
    func increaseLife() {
        if life < maxlife {
            life++
        }
    }
    func decreaseLife() {
        life--
    }
    
    var isGameOver: Bool {
        if (life <= 0) {
            return true
        }
        return false
    }
    
    func resetGame() {
        score = 0;
        life = 5;
    }
    
    // ------------------------------------------------------------
    // Helper functions
    
    /**
     Given two categories, returns true if the node and bin are matching. False otherwise
    */
    class func checkMatchingBin(firstCategory:UInt32, secondCategory:UInt32) -> Bool {
        if (firstCategory == Constants.trashNodeCategory || secondCategory == Constants.trashNodeCategory) {
            return firstCategory == Constants.trashBinCategory || secondCategory == Constants.trashBinCategory
        }
        if (firstCategory == Constants.recycleNodeCategory || secondCategory == Constants.recycleNodeCategory) {
            return firstCategory == Constants.recycleBinCategory || secondCategory == Constants.recycleBinCategory
        }
        if (firstCategory == Constants.miscNodeCategory || secondCategory == Constants.miscNodeCategory) {
            return firstCategory == Constants.miscBinCategory || secondCategory == Constants.miscBinCategory
        }
        if (firstCategory == Constants.powerupNodeCategory || secondCategory == Constants.powerupNodeCategory) {
            return true // Powerups don't have penalties for missing them
        }
        return false
    }
    
    /**
     Given two bodies (e.g. from the didBeginContact()) returns the SKNode that is the throwable node
     If none of them are, then the optional is not set.
    */
    class func getThrowableFromBody(firstBody:SKPhysicsBody, secondBody: SKPhysicsBody) -> SKNode? {
        if firstBody.categoryBitMask > 0 && firstBody.categoryBitMask < Constants.trashBinCategory {
            return firstBody.node
        }
        if secondBody.categoryBitMask > 0 && secondBody.categoryBitMask < Constants.trashBinCategory {
            return secondBody.node
        }
        
        return nil
    }
    
}
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

class TN_Model {
    
    var score = 0

    var life = 5
    var maxlife = 5
    
    func increaseScore() {
        score++
    }
    
    func increaseLife() {
        life++
    }
    func decreaseLife() {
        life--
    }
    
    /**
     Creates a random TrashNode
     */
    func createTrash() {
        
    }
    
    // ------------------------------------------------------------
    // Helper functions
    
    /**
     Given two categories, returns true if the node and bin are matching. False otherwise
    */
    class func checkMatchingBin(firstCategory:UInt32, secondCategory:UInt32) -> Bool {
        if (firstCategory == secondCategory) {
            return true
        }
        return false;
    }
    
    /**
     Given two bodies (e.g. from the didBeginContact()) returns the trashnode
    */
    class func getTrashNodeFromBody(firstContact:SKPhysicsBody, secondBody: SKPhysicsBody) {
        
    }
    
}
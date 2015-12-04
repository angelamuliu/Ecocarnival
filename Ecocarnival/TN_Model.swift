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
 Trash ninja game model - Keeps track of score, life, and game state. Also has functions to add throwables to the pool, calculate which 
 should appear next depending on percentages and what's available in the pools currently, and some other helpful methods related to the game.
*/
class TN_Model {
    
    var level = 1
    var maxLevels = 7
    
    var currLevelPointer = 0
    var levelStages = [4, 9, 15, 22, 30, 40, 55] // The points for each level to advance
    
    var spawnRate = 3.0 // Number of seconds between spawning of throwables
    
    var score = 0
    var life = 5
    var maxlife = 5
    
    // Pool of throwables currently in game. We always start the game with the chocolate trash and can recyclable
    // Format: ["Common" : [ [...], [...] ], "Uncommon" ... ]
    var trashPool = [Constants.common : [TextAssets.trashAssets[0]] ]
    var recyclePool = [Constants.common : [TextAssets.recycleAssets[0]] ]
    
    // Indexes of trash and recycle that has yet to be added to the available pool
    // For now, hardcoded to the indexes available. Probably in future, the initializer would be more refined lol
    var lockedTrash = [1,2,3]
    var lockedRecycle = [1,2,3]
    
    var isGameOver: Bool {
        if (life <= 0) {
            return true
        }
        return false
    }
    
    var isMaxLevel: Bool {
        if level >= maxLevels {
            return true
        }
        return false
    }
    
    var toNextLevel: Int {
        return levelStages[currLevelPointer]
    }
    
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
    
    func increaseLevel() {
        if level != maxLevels {
            level++
            spawnRate = spawnRate - 0.32
            currLevelPointer++
        }
    }
    
    func resetGame() {
        score = 0
        life = 5
        level = 1
        currLevelPointer = 0
        spawnRate = 4
        resetPools()
    }
    
    private func resetPools() {
        trashPool = [Constants.common : [TextAssets.trashAssets[0]] ]
        recyclePool = [Constants.common : [TextAssets.recycleAssets[0]] ]
        lockedTrash = [1,2,3]
        lockedRecycle = [1,2,3]
    }
    
    // ------------------------------------------------------------
    
    /**
     Adds either new trash or recyclable to the game's available pool
    */
    func addNewThrowable() -> [String:String] {
        let randomNum = arc4random_uniform(UInt32(2))
        if randomNum == 0 || lockedRecycle.count < 1 { // Adding trash
            let i = Int(arc4random_uniform(UInt32(lockedTrash.count)))
            let assetIndex = lockedTrash.removeAtIndex(i)
            addToPool(&trashPool, asset: TextAssets.trashAssets[assetIndex])
            return TextAssets.trashAssets[assetIndex]
        } else { // Adding recyclable
            let i = Int(arc4random_uniform(UInt32(lockedRecycle.count)))
            let assetIndex = lockedRecycle.removeAtIndex(i)
            addToPool(&recyclePool, asset: TextAssets.recycleAssets[assetIndex])
            return TextAssets.recycleAssets[assetIndex]
        }
    }
    
    private func addToPool(inout pool: [String: [[String: String]]], asset: [String: String]) {
        let rarity = asset["rarity"]!
        if pool[rarity] == nil {
            pool[rarity] = [[String:String]]()
        }
        pool[rarity]!.append(asset)
    }
    
    /**
    Creates a random trash node (trash, recyclable, misc, or powerup) thats available given this game's current
    pool of available things given a location to create it in.
    40% change of trash or recyclable, 10% misc, and 10% powerup. Then uses the pool to determine which to spawn
    */
    func generateRandomTrash(location: CGPoint) -> Throwable {
        let randomNum = arc4random_uniform(UInt32(100)) // Number between 0 - 99
        if randomNum < 40 {
            return TrashNode(location: location, asset: chooseTrashFromPool())
        } else if randomNum >= 40 && randomNum < 80 {
            return RecycleNode(location: location, asset: chooseRecycleFromPool())
        } else if randomNum >= 80 && randomNum < 85 {
            return PowerupNode(location: location)
        } else {
            return MiscNode(location: location)
        }
    }
    
    /**
     Given a pool to work with, returns a string rarity based on rarity percentage of occuring
     and what rarities are even available
    */
    private func chooseRarity(pool: [String: [[String: String]]]) -> String {
        var poolPossibilities = 100
        if pool[Constants.uncommon] == nil {
            poolPossibilities = poolPossibilities - Constants.uncommon_percent
        }
        if pool[Constants.rare] == nil {
            poolPossibilities = poolPossibilities - Constants.rare_percent
        }
        let randomNum = Int(arc4random_uniform(UInt32(poolPossibilities)))
        if randomNum < Constants.common_percent {
            return Constants.common
        } else {
            if pool[Constants.uncommon] != nil && pool[Constants.rare] != nil {
                if randomNum >= Constants.common_percent + Constants.uncommon_percent + Constants.rare_percent {
                    return Constants.rare
                } else {
                    return Constants.uncommon
                }
            }
            if pool[Constants.uncommon] != nil {
                return Constants.uncommon
            } else {
                return Constants.rare
            }
        }
    }
    
    private func chooseTrashFromPool() -> [String:String] {
        let rarity = chooseRarity(trashPool)
        return trashPool[rarity]![Int(arc4random_uniform(UInt32(trashPool[rarity]!.count)))]
    }
    
    private func chooseRecycleFromPool() -> [String:String] {
        let rarity = chooseRarity(recyclePool)
        return recyclePool[rarity]![Int(arc4random_uniform(UInt32(recyclePool[rarity]!.count)))]
    }
    
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
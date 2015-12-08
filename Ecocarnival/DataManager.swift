//
//  DataManager.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/7/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation

/**
 Used to save high scores!
*/
class DataManager {
    
    // Array of top 10 high scores
    var highScores = [Int]()
    
    init() {
        loadHighScores()
    }
    
    func documentsDirectory() -> NSURL {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> NSURL {
        return documentsDirectory().URLByAppendingPathComponent("HighScores.plist")
    }
    
    /**
     Clears all high scores
    */
    func resetHighScores() {
        highScores = [Int]()
        saveHighScores()
    }
    
    /**
     Checks to see if a score can go in the top 10. If so, it'll get added to the top 10!
     Returns true if score got added to top. False if score wasn't good enough
    */
    func addHighScore(score:Int) -> Bool {
        if score > 0 {
            if highScores.count < 10 {
                highScores.append(score)
                highScores.sortInPlace(>)
                saveHighScores()
                return true
            }
            if score > highScores[highScores.count - 1] {
                highScores.append(score)
                highScores.sortInPlace(>)
                if highScores.count > 10 { // We only keep track of the top 10...
                    highScores.removeAtIndex(highScores.count - 1)
                }
                saveHighScores()
                return true
            }
        }
        return false
    }
    
    /**
     Saves the high score array into our plist
    */
    func saveHighScores() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(highScores, forKey: "Score")
        archiver.finishEncoding()
        data.writeToURL(dataFilePath(), atomically: true)
    }
    
    /**
     Loads in the high scores, which is an array of top 10 scores
    */
    func loadHighScores() {
        let path = dataFilePath()
        if path.checkResourceIsReachableAndReturnError(NSErrorPointer()) {
            if let data = NSData(contentsOfURL: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                self.highScores = unarchiver.decodeObjectForKey("Score") as! [Int]
                unarchiver.finishDecoding()
            }
        }
    }
    
}
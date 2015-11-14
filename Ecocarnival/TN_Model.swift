//
//  Model.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/11/15.
//  Copyright © 2015 amliu. All rights reserved.
//


// Trash Ninja Game Logic

import Foundation

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
    
}
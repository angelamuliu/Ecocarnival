//
//  TextAssets.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/3/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation

/**
 All text assets used in the game, from the name of images and their descriptions, to
 other flavor text
*/
struct TextAssets {
    
    static let trashAssets = [
        ["imageNamed" : "TN_trash1.png",
            "desc" : "A half-eaten chocolate bar.\nIt can't be recycled, because you can't reuse...old food.",
            "rarity" : Constants.common ],
        ["imageNamed" : "TN_trash2.png",
            "desc" : "A plastic bag.\nIn the trash it goes!",
            "rarity" : Constants.common ],
        ["imageNamed" : "TN_trash3.png",
            "desc" : "Pizza on a paper plate.\nI think the cheese is molding. Throw it in the trash",
            "rarity" : Constants.uncommon ],
        ["imageNamed" : "TN_trash4.png",
            "desc" : "A juice pouch!\nOh, it's empty. Belongs in the trash.",
            "rarity" : Constants.rare ]
    ]
    
    static let recycleAssets = [
        ["imageNamed" : "TN_recycle1.png",
            "desc" : "An empty aluminum soda can.\nMetal can be recycled!",
            "rarity" : Constants.common ],
        ["imageNamed" : "TN_recycle2.png",
            "desc" : "A cardboard box.\nMake sure to flatten it before recycling!",
            "rarity" : Constants.common ],
        ["imageNamed" : "TN_recycle3.png",
            "desc" : "Mon dieu, we're out of wine!\nThe bottle can be reused. It gets crushed and reheated into beautiful new glass!",
            "rarity" : Constants.rare ],
        ["imageNamed" : "TN_recycle4.png",
            "desc" : "A week old newspaper.\nAt the recycling plant, it gets turned into a slurry and rerolled.",
            "rarity" : Constants.uncommon ]
    ]
    
    static let miscAssets = [
        ["imageNamed" : "TN_misc1.png",
            "desc" : "Squirrels are evil fluffballs.",
            "rarity" : Constants.common ],
        ["imageNamed" : "TN_misc2.png",
            "desc" : "Rabbits don't belong in the trash!",
            "rarity" : Constants.uncommon ],
        ["imageNamed" : "TN_misc3.png",
            "desc" : "Rats are literally the worst.",
            "rarity" : Constants.common ]
    ]
    
    static let lifePowerAsset = ["imageNamed" : "TN_lifeorb.png", "desc" : "A beautiful green orb that increases your life.", "rarity" : Constants.common ]
    
    
}
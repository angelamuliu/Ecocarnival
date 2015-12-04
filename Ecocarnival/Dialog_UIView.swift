//
//  Dialog_UIView.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/3/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import UIKit

/**
 A special UIView that acts as a popup modal in from of the game. It begins offscreen, is partially clear, and has inner components
 (wordContainer -> The speech bubble)
*/
class Dialog_UIView:UIView {
    
    var catView:UIImageView?
    
    var wordContainer:UIView? // Contains the dialog
    var textContainer:UITextView?
    
    var modalScoreViews = [UIImageView]() // Collection of images representing a score
    
    var restartButton:UIButton?
    var homeButton:UIButton?
    
    var newTrashImage:UIImageView?
    var newTrashDescContainter:UITextView?
    var nextLevelButton:UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Initializes the Dialog UIView that matches the size of a scene and optionally displays text
    */
    init(gameScene: TN_GameScene, text: String?) {
        super.init(frame: CGRect(x: 0, y: gameScene.size.height, width: gameScene.size.width, height: gameScene.size.height))
        self.layer.opacity = 0.0
        
        self.wordContainer = UIView(frame: CGRect(x: gameScene.size.width/6, y: 30, width: (gameScene.size.width/6)*4, height: gameScene.size.height / 1.5))
        self.wordContainer!.backgroundColor = UIColor.whiteColor()
        self.wordContainer!.layer.borderWidth = 8;
        self.wordContainer!.layer.borderColor = Constants.navyColor.CGColor
    
        // Dumb fix to a dumb visual glitch where the border leaves 1 px of white space at the top
        let topfill = UIView(frame: CGRect(x: 0, y: 0, width: self.wordContainer!.frame.width, height:5))
        topfill.backgroundColor = Constants.navyColor
        self.wordContainer?.addSubview(topfill)
        
        // Adding light blue gradient color to the word container
        // http://stackoverflow.com/questions/23074539/programmatically-create-a-uiview-with-color-gradient
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = CGRect(x: 0, y:0, width: wordContainer!.bounds.width, height: wordContainer!.bounds.height / 4)
        topGradient.colors = [Constants.lightBlueColor.CGColor, UIColor.whiteColor().CGColor]
        self.wordContainer!.layer.insertSublayer(topGradient, atIndex: 0)
        
        let botGradient: CAGradientLayer = CAGradientLayer()
        botGradient.frame = CGRect(x: 0, y: (wordContainer!.bounds.height/4)*3, width: wordContainer!.bounds.width, height: wordContainer!.bounds.height / 4)
        botGradient.colors = [UIColor.whiteColor().CGColor, Constants.lightBlueColor.CGColor]
        self.wordContainer!.layer.insertSublayer(botGradient, atIndex: 0)
        
        // Drop shadow
        self.wordContainer!.layer.shadowOffset = CGSize(width: 0, height: 7)
        self.wordContainer!.layer.shadowOpacity = 0.5
        self.wordContainer!.layer.shadowRadius = 5.0
        
        // Adding the text of variable length into the word container
        self.textContainer = UITextView(frame: CGRect(x: wordContainer!.frame.width/6, y: 20, width: (wordContainer!.frame.width/6)*4, height: 300))
        self.textContainer!.scrollEnabled = false // Making it labelike by disabling user interaction and scrolling
        self.textContainer!.userInteractionEnabled = false
        self.textContainer!.backgroundColor = UIColor.clearColor()
        self.textContainer!.textAlignment = .Center
        self.textContainer!.font = UIFont(name: "Helvetica-Bold", size: 18)
        self.textContainer!.text = text
        
        self.wordContainer!.addSubview(self.textContainer!)
        self.addSubview(wordContainer!)
        
        // The cat image goes on top
        self.catView = UIImageView(image: UIImage(named: "Talkcat"))
        self.catView!.frame = CGRect(x: gameScene.size.width/4, y: (gameScene.size.height/3)*2, width: gameScene.size.width/2, height: gameScene.size.height/3)
        self.catView!.contentMode = .ScaleAspectFill
        self.catView!.layer.shadowOpacity = 0.3
        self.catView!.layer.shadowRadius = 5.0
        
        self.addSubview(catView!)
    }
    
    
    /**
     Plays the fade slide up animation for this modal to go over its scene
     */
    func slideUpDialog() {
        UIView.animateWithDuration(0.3,
            animations: { void in
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.layer.opacity = 1.0
            },
            completion: { finished in
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        })
    }
    
    /**
     Plays the fade slide down animation for this modal. It can be passed a completion block to do after
     */
    func slideDownDialog(completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.3,
            animations: { void in
                self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
                self.layer.opacity = 0.0
            },
            completion: completion)
        
    }
    
    /**
     Reset the text rendered in the dialog UIView
    */
    func resetText(text: String) {
        self.textContainer!.text = text
    }
    
    /**
     Sets up the restart button element if necessary and places in the UIView. To connect the restart button to a method, use:
     >> restartButton.addTarget(self, action: "resetGame:", forControlEvents: .TouchUpInside)
    */
    func addRestartButton() {
        if self.restartButton == nil {
            setupRestartButton()
        }
        if self.restartButton?.superview == nil{
            self.addSubview(self.restartButton!)
        }
    }
    
    /**
     Removes the restart button from this UIView
    */
    func removeRestartButton() {
        if self.restartButton?.superview != nil {
            self.restartButton?.removeFromSuperview()
        }
    }
    
    func setupRestartButton() {
        self.restartButton = UIButton(frame: CGRect(x: self.frame.width/4, y: 180, width: self.frame.width/5, height: 40))
        self.restartButton!.layer.cornerRadius = 4.0
        self.restartButton!.setTitle("Replay", forState: UIControlState.Normal)
        self.restartButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.restartButton!.backgroundColor = Constants.orangeColor
        self.restartButton!.layer.borderWidth = 3
        self.restartButton!.layer.borderColor = Constants.bloodOrangeColor.CGColor
    }
    
    /**
     Sets up the back to home button element if necessary and places in the UIView. To connect this button to a method, use:
     >> homeButton.addTarget(self, action: "backToHome:", forControlEvents: .TouchUpInside)
    */
    func addBackToHomeButton() {
        if self.homeButton == nil {
            setupBackToHomeButton()
        }
        if self.homeButton?.superview == nil{
            self.addSubview(self.homeButton!)
        }
    }
    
    /**
     Removes the restart button from this UIView
     */
    func removeBackToHomeButton() {
        if self.homeButton?.superview != nil {
            self.homeButton?.removeFromSuperview()
        }
    }
    
    func setupBackToHomeButton() {
        self.homeButton = UIButton(frame: CGRect(x: (self.frame.width/4)*3 - self.frame.width/5, y: 180, width: self.frame.width/5, height: 40))
        self.homeButton!.layer.cornerRadius = 4.0
        self.homeButton!.setTitle("Quit", forState: UIControlState.Normal)
        self.homeButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.homeButton!.backgroundColor = Constants.lightGreyColor
        self.homeButton!.layer.borderWidth = 3
        self.homeButton!.layer.borderColor = Constants.greyColor.CGColor
    }
    
    /**
     Resets and adds the score images given some score to render
    */
    func addScore(score:Int) {
        removeScore() // Clear previous score elements
        setupScore(score, center: CGPoint(x: self.frame.width / 2, y: 135))
        for scoreView in self.modalScoreViews { // Attach the new scoreviews
            self.addSubview(scoreView)
        }
    }
    
    /**
     Removes the score elements from this UIView
    */
    func removeScore() {
        if self.modalScoreViews.count > 0 && self.modalScoreViews[0].superview != nil {
            for scoreView in self.modalScoreViews {
                scoreView.removeFromSuperview()
            }
        }
    }
    
    /**
     Initializes a score with the handwritten font for UIViews given some point that acts as the center
     */
    func setupScore(score:Int, center: CGPoint) {
        self.modalScoreViews = [UIImageView]()
        let scoreArr = Array(String(score).characters) // We split it e.g. ["1", "0", "2"]
        let centerIndex = scoreArr.count / 2
        
        let numWidth = CGFloat(25.0)
        let numHeight = CGFloat(40.0)
        
        while (scoreArr.count > self.modalScoreViews.count) {
            let image = UIImage(named: UI_Components.getScoreNodeNumber(scoreArr[scoreArr.count - self.modalScoreViews.count - 1]))!
            let scoreView = UIImageView(image: image)
            scoreView.frame = CGRect(x: center.x - (CGFloat(self.modalScoreViews.count - centerIndex) * numWidth) - numWidth/2, y: center.y - numHeight/2, width: numWidth, height: numHeight)
            scoreView.contentMode = .ScaleAspectFit
            self.modalScoreViews.insert(scoreView, atIndex: 0)
        }
    }
    
    /**
     An image that shows a throwable image and description that has been added to the next level
    */
    func newTrashDisplay(imageNamed:String, desc:String) {
        removeNewTrashDisplay()
        
        if newTrashImage == nil { // Perform initialization if elements not made yet
            setupNewTrashDisplay(imageNamed, desc: desc)
        }
        newTrashImage!.image = UIImage(named:imageNamed)
        newTrashDescContainter!.text = desc
        
        self.wordContainer!.addSubview(newTrashImage!)
        self.wordContainer!.addSubview(newTrashDescContainter!)
    }
    
    /**
     Remove the new trash displayer
    */
    func removeNewTrashDisplay() {
        if newTrashImage != nil && newTrashImage?.superview != nil {
            newTrashImage?.removeFromSuperview()
            newTrashDescContainter?.removeFromSuperview()
        }
    }
    
    func setupNewTrashDisplay(imageNamed:String, desc:String) {
        let image = UIImage(named: imageNamed)
        newTrashImage = UIImageView(image: image)
        newTrashImage!.frame = CGRect(x: 40, y: 83, width: 80, height: 80)
        newTrashImage!.contentMode = .ScaleAspectFit
        
        newTrashDescContainter = UITextView(frame: CGRect(x: 130, y: 83, width: self.wordContainer!.frame.width - 170, height: 100))
        newTrashDescContainter!.scrollEnabled = false // Making it labelike by disabling user interaction and scrolling
        newTrashDescContainter!.userInteractionEnabled = false
        newTrashDescContainter!.backgroundColor = UIColor.clearColor()
        newTrashDescContainter!.font = UIFont(name: "Helvetica", size: 16)
        newTrashDescContainter!.contentMode = .TopLeft
        newTrashDescContainter!.text = desc
    }

    


}
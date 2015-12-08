//
//  TN_ScoreViewController.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/7/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit
import SpriteKit


class TN_ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var scoreTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.dataManager.loadHighScores()
        self.scoreTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Load the BG image
        let backgroundImageView = UIImageView(image: UIImage(named: "Scoreboard"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .ScaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    override func viewWillLayoutSubviews() {
        // Called whenever a new view is added
        super.viewWillLayoutSubviews()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    // Implementing Table View Methods
    // Help from: https://www.weheartswift.com/how-to-make-a-simple-table-view-with-ios-8-and-swift/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.dataManager.highScores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.scoreTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = "#" + String(indexPath.row + 1) + ". " + String(appDelegate.dataManager.highScores[indexPath.row]) + " points"
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        return cell
    }
    
}

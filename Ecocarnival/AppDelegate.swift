//
//  AppDelegate.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/9/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager = DataManager()
    
    // BG music player for all screens
    var backgroundMusic : AVAudioPlayer?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    func applicationWillResignActive(application: UIApplication) {
        backgroundMusic?.pause()
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(application: UIApplication) {
        backgroundMusic?.pause()
    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(application: UIApplication) {
        backgroundMusic?.pause()
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(application: UIApplication) {
        backgroundMusic?.play()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // ------------------------------------------------------------
    // Music playing functions that can be accessed anywhere since music is shared throughout the app
    
    // http://www.raywenderlich.com/114298/learn-to-code-ios-apps-with-swift-tutorial-5-making-it-beautiful
    /**
    Given a name and type of the audio file, returns the audio player that can be used to play the sound
    */
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
    func play_quirkydog_1() {
        if let music = setupAudioPlayerWithFile("Quirky Dog", type: "mp3") {
            backgroundMusic?.stop()
            
            backgroundMusic = music
            backgroundMusic?.numberOfLoops = -1 // loops forever
            backgroundMusic?.volume = 0.1
            backgroundMusic?.play()
        }
    }
    
    
    func play_quirkydog_2() {
        if let music = setupAudioPlayerWithFile("Quirky Dog_speed2", type: "mp3") {
            backgroundMusic?.stop()
            
            backgroundMusic = music
            backgroundMusic?.numberOfLoops = -1 // loops forever
            backgroundMusic?.volume = 0.1
            backgroundMusic?.play()
        }
    }
    
    func play_quirkydog_3() {
        if let music = setupAudioPlayerWithFile("Quirky Dog_speed3", type: "mp3") {
            backgroundMusic?.stop()
            
            backgroundMusic = music
            backgroundMusic?.numberOfLoops = -1 // loops forever
            backgroundMusic?.volume = 0.1
            backgroundMusic?.play()
        }
    }
    
    func stop_music() {
        backgroundMusic?.stop()
    }


}


//
//  AppDelegate.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard!
    var myRootViewController: UITabBarController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        myRootViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTabBarController") as! UITabBarController
        
        
        //MARK: Setting user

        if Utility.sharedInstance.setUser() {
            self.window?.rootViewController = myRootViewController //settare nuovo view initial view controller per eseguire questo metodo nel dispatcher
        }
        
        return true
    }
}


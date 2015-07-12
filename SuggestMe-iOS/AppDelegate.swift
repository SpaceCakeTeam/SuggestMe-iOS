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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		if UIDevice.currentDevice().systemVersion >= "8.0" {
			var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
			var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
			UIApplication.sharedApplication().registerUserNotificationSettings(setting);
			UIApplication.sharedApplication().registerForRemoteNotifications();
		} else {
			UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Badge)
		}
        return true
    }
	
	//MARK: Push Notifications!
	
	func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		//send this device token to server
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		println(error)
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		//TODO
		println("Recived: \(userInfo)")
		//Parsing userinfo:
		var temp : NSDictionary = userInfo
		if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
		{
			var alertMsg = info["alert"] as! String
			var alert: UIAlertView!
			alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
	}
}


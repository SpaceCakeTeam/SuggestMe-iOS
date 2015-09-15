//
//  AppDelegate.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard!
	var helpers = Helpers.shared

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        return true
    }
	
	func applicationDidBecomeActive(application: UIApplication) {
		if helpers.isStored("user") {
			if helpers.isPushRegisteredAtLeastOneTime() {
				if helpers.pushChanged() {
					helpers.pushEnabled() ? helpers.updatePushRequest(helpers.dataStored("remoteNotificationPushToken") as! String) : helpers.updatePushRequest("")
				}
			} else {
				helpers.registerPush()
			}
		}
	}
	
	//MARK: Facebook!
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
	}
	
	//MARK: Push Notifications!
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		print("Registration Push OK!")
		helpers.updatePushRequest(deviceToken.description.stringByReplacingOccurrencesOfString("[ <>]", withString: "", options: .RegularExpressionSearch, range: nil))
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		//Show alert
		print("Registration Push KO!")
		print(error)
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
		print("Received Push Notification: \(userInfo)")
	}
}


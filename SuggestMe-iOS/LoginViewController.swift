//
//  LoginViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	var helpers = Helpers.shared
	var navigationBarHeight: CGFloat!
	
	var backgroundView: UIImageView!
    var loginSocialButtons: UIButton!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationBarHeight = self.navigationController!.navigationBar.frame.height
		self.view.frame.size = CGSizeMake(helpers.screenWidth, helpers.screenHeightNoStatus)
		helpers.currentView = self.view
		helpers.currentViewFrame = CGRectMake(0, 0, helpers.screenWidth, helpers.screenHeightNoStatus-navigationBarHeight)
		
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: helpers.getTextLocalized("Indietro"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismiss:"))
        
        backgroundView = UIImageView(image: UIImage(named: "LoginBackground-\(Int(helpers.screenHeight))h"))
        self.view.addSubview(backgroundView)
      
        var loginSocialImageView = UIImageView(image: UIImage(named: "LoginSocialButtons-\(Int(helpers.screenHeight))h"))
        loginSocialImageView.frame.origin = CGPointMake(backgroundView.frame.origin.x + (backgroundView.frame.width/2 - loginSocialImageView.frame.width/2), backgroundView.frame.height/2 - loginSocialImageView.frame.height/2)
        self.view.addSubview(loginSocialImageView)
        
        loginSocialButtons = UIButton(frame: loginSocialImageView.frame)
        loginSocialButtons.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginSocialButtons)
	}
    
    //MARK: UIButton Actions
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }

    func login(sender: AnyObject) {		
        if sender as! UIButton == loginSocialButtons {
            helpers.user.anon = false
			//helpers.getFacebookAccount() select with frame of touch //TODO
			//helpers.getTwitterAccount() select with frame of touch //TODO
			helpers.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com") //TODO
        }
        
        helpers.communicationHandler.registrationRequest() { (response) -> () in
            if response {
				dispatch_sync(dispatch_get_main_queue(), { () -> Void in
					self.dismissViewControllerAnimated(true, completion: { () -> Void in })
				})
			} else {
				self.helpers.user.anon = true
			}
        }
    }
    
    //MARK: Touches methods
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		//get position of touch //TODO
    }
}

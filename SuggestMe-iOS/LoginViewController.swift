//
//  LoginViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var backgroundView: UIImageView!
    
    var loginSocialButtons: UIButton!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Indietro", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismiss:"))
        
        backgroundView = UIImageView(image: UIImage(named: "LoginBackground-\(Utility.sharedInstance.screenSizeH)h"))
        self.view.addSubview(backgroundView)
      
        var loginSocialImageView = UIImageView(image: UIImage(named: "LoginSocialButtons-\(Utility.sharedInstance.screenSizeH)h"))
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
        self.view.addSubview(Utility.sharedInstance.setActivityIndicator(self.view.frame))
        
        if sender as! UIButton == loginSocialButtons {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getFacebookAccount()
            //Utility.sharedInstance.getTwitterAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        }
        
        Utility.sharedInstance.communicationHandler.registrationRequest() { (response) -> () in
            println("Registration Request response: \(response)")
            if response {
				dispatch_sync(dispatch_get_main_queue(), { () -> Void in
					self.dismissViewControllerAnimated(true, completion: { () -> Void in })
				})
			}
        }
    }
    
    //MARK: Touches methods
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //get position of touch
    }
}

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

    //MARK: UI methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismiss:"))
        
        backgroundView = UIImageView(image: UIImage(named: "LoginBackground"))
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        
        var loginFacebookButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height/2-self.view.frame.width/3, width: self.view.frame.width, height: self.view.frame.width/2))
        loginFacebookButton.setImage(UIImage(named: "LoginFacebookButton"), forState: UIControlState.Normal)
        loginFacebookButton.addTarget(self, action: Selector("loginWithFacebook:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        var loginTwitterButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height/2-self.view.frame.width/3+5, width: self.view.frame.width, height: self.view.frame.width/2))
        loginTwitterButton.setImage(UIImage(named: "LoginTwitterButton"), forState: UIControlState.Normal)
        loginTwitterButton.addTarget(self, action: Selector("loginWithTwitter:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(loginFacebookButton)
        self.view.addSubview(loginTwitterButton)
    }
    
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
    
    func setActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.addSubview(Utility.sharedInstance.setActivityIndicator(self.backgroundView.frame, text: "logging in..."))
        }
    }
    
    
    //MARK: Login methods
    
    func loginWithFacebook(sender: AnyObject) {
        setActivityIndicator()
        
        Utility.sharedInstance.user.anon = false
        Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        
        Utility.sharedInstance.communicationHandler.registrationRequest() { (response) -> () in
            println("Faceboom Registration Request response: \(response)")
            if response {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in })
            }
            Utility.sharedInstance.activityIndicatorView.removeFromSuperview()
        }
    }
    
    func loginWithTwitter(sender: AnyObject) {
        setActivityIndicator()
        
        Utility.sharedInstance.user.anon = false
        Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        
        Utility.sharedInstance.communicationHandler.registrationRequest() { (response) -> () in
            println("Twitter Registration Request response: \(response)")
            if response {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in })
            }
            Utility.sharedInstance.activityIndicatorView.removeFromSuperview()
        }
    }
}

//
//  LoginViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let screenSize = Int(UIScreen.mainScreen().bounds.size.height)

    var backgroundView: UIImageView!
    
    var loginFacebookButton: UIButton!
    var loginTwitterButton: UIButton!
    

    //MARK: UI methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismiss:"))
        
        backgroundView = UIImageView(image: UIImage(named: "LoginBackground-\(screenSize)h"))
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        
        var loginFacebookImage = UIImage(named: "LoginFacebookButton")
        var loginFacebookImageView = UIImageView(image: loginFacebookImage)
        loginFacebookButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - loginFacebookImageView.frame.width/2, y: self.view.frame.height/2 - loginFacebookImageView.frame.height/2-2, width: loginFacebookImageView.frame.width, height: loginFacebookImageView.frame.height))
        loginFacebookButton.setImage(loginFacebookImage, forState: UIControlState.Normal)
        loginFacebookButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginFacebookButton)

        var loginTwitterImage = UIImage(named: "LoginTwitterButton")
        var loginTwitterImageView = UIImageView(image: loginTwitterImage)
        loginTwitterButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - loginTwitterImageView.frame.width/2, y: self.view.frame.height/2 - loginTwitterImageView.frame.height/2+2, width: loginTwitterImageView.frame.width, height: loginTwitterImageView.frame.height))
        loginTwitterButton.setImage(loginTwitterImage, forState: UIControlState.Normal)
        loginTwitterButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginTwitterButton)
    }
    
    
    //MARK: UIButton Actions
    
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }

    func login(sender: AnyObject) {
        var button = sender as! UIButton
        button.enabled = false
        self.view.addSubview(Utility.sharedInstance.setActivityIndicator(self.view.frame))
        
        if button == loginFacebookButton {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getFacebookAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        } else if button == loginTwitterButton {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getTwitterAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        }
        
        Utility.sharedInstance.communicationHandler.registrationRequest() { (response) -> () in
            println("Registration Request response: \(response)")
            if response {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in })
            } else {
                button.enabled = true
            }
        }
    }
    
    
    //MARK: Touches methods
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //get position of touch
    }
}

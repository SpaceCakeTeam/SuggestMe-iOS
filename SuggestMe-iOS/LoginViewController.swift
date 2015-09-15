//
//  LoginViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Indietro".localized, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismiss:"))
        
        backgroundView = UIImageView(image: UIImage(named: "LoginBackground-\(Int(helpers.screenHeight))h"))
        self.view.addSubview(backgroundView)
      
        let loginSocialImageView = UIImageView(image: UIImage(named: "LoginSocialButtons-\(Int(helpers.screenHeight))h"))
        loginSocialImageView.frame.origin = CGPointMake(backgroundView.frame.origin.x + (backgroundView.frame.width/2 - loginSocialImageView.frame.width/2), backgroundView.frame.height/2 - loginSocialImageView.frame.height/2)
        self.view.addSubview(loginSocialImageView)
        
        loginSocialButtons = UIButton(frame: loginSocialImageView.frame)
		loginSocialButtons.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("socialLogin:")))
		self.view.addSubview(loginSocialButtons)
	}
    
    //MARK: UIButton Actions
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }

	func socialLogin(gestureRecognizer: UITapGestureRecognizer) {
		if gestureRecognizer.state == UIGestureRecognizerState.Ended {
			if helpers.isRightShape(gestureRecognizer.locationInView(loginSocialButtons), frame: loginSocialButtons.frame) {
				helpers.setFacebookUser({ (response) -> () in
					response ? self.makeRegistration(0) : print("facebook error")
				})
			} else {
				helpers.setTwitterUser({ (response) -> () in
					response ? self.makeRegistration(0) : print("twitter error")
				})
			}
		}
	}
	
	func makeRegistration(sender: AnyObject) {
		helpers.communicationHandler.registrationRequest() { (response) -> () in
			if response {
				dispatch_async(dispatch_get_main_queue()) {
					self.dismissViewControllerAnimated(true, completion: { () -> Void in })
				}
			}
		}
	}
}

//
//  AboutViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 10/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
	
	var helpers = Helpers.shared
	var navigationBarHeight: CGFloat!
	var tabBarHeight: CGFloat!

    var loginButton: UIBarButtonItem!

    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationBarHeight = self.navigationController!.navigationBar.frame.height
		tabBarHeight = self.tabBarController!.tabBar.frame.height
		self.view.frame.size = CGSizeMake(helpers.screenWidth, helpers.screenHeightNoStatus)
		helpers.currentView = self.view
		helpers.currentViewFrame = CGRectMake(0, 0, helpers.screenWidth, helpers.screenHeightNoStatus-navigationBarHeight-tabBarHeight)
		
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default

        loginButton = UIBarButtonItem(title: helpers.getTextLocalized("Log In"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var backgroundView = UIImageView(image: UIImage(named: "AboutBackground-\(Int(helpers.screenHeight))h"))
        self.view.addSubview(backgroundView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		helpers.user.anon == true ? self.navigationItem.setRightBarButtonItem(loginButton, animated: false) : self.navigationItem.setRightBarButtonItem(nil, animated: false)
    }
	
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
}
//
//  LoginViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismiss:"))
        
        var backgroundView = UIImageView(image: UIImage(named: "LoginBackground"))
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
    }
    
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }
}

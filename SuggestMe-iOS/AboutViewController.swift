//
//  AboutViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 10/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var backgroundView = UIImageView(image: UIImage(named: "AboutBackground"))
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
    }
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
}
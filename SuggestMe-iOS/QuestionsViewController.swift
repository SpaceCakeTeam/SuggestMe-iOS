//
//  QuestionsViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var backgroundView = UIImageView(image: UIImage(named: "QuestionsBackground"))
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
    }
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.selectedIndex = 2
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.selectedIndex = 0
    }
}


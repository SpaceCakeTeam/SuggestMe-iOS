//
//  CategoriesViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var categorySocialButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height/2))
        categorySocialButton.setImage(UIImage(named: "CategorySocialButton"), forState: UIControlState.Normal)
        self.view.addSubview(categorySocialButton)
        
        var categoryGoodsButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2))
        categoryGoodsButton.setImage(UIImage(named: "CategoryGoodsButton"), forState: UIControlState.Normal)
        self.view.addSubview(categoryGoodsButton)
    }
    
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
}


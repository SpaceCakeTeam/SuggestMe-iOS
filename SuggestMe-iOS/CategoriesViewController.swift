//
//  CategoriesViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    var categorySocialButton: UIButton!
    var categoryGoodsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default

        categorySocialButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height/2))
        categorySocialButton.setImage(UIImage(named: "CategorySocialButton"), forState: UIControlState.Normal)
        categorySocialButton.addTarget(self, action: Selector("askSuggestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(categorySocialButton)
        
        categoryGoodsButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2))
        categoryGoodsButton.setImage(UIImage(named: "CategoryGoodsButton"), forState: UIControlState.Normal)
        categoryGoodsButton.addTarget(self, action: Selector("askSuggestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(categoryGoodsButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Utility.sharedInstance.user.anon == true {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func askSuggestion(sender: AnyObject) {
        if sender as! UIButton == categorySocialButton {
            Utility.sharedInstance.currentQuestion = Question(id: -1, questiondata: QuestionData(catid: 0, subcatid: -1, text: "", anon: true), date: 0, suggest: nil)
        } else if sender as! UIButton == categoryGoodsButton {
            Utility.sharedInstance.currentQuestion = Question(id: -1, questiondata: QuestionData(catid: 1, subcatid: -1, text: "", anon: true), date: 0, suggest: nil)
        }
        self.performSegueWithIdentifier("pushToQuestionViewController", sender: self)
    }
}


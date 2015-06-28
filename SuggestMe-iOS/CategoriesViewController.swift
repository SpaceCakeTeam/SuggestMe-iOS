//
//  CategoriesViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    var loginButton: UIBarButtonItem!
    var socialButton: UIButton!
    var goodsButton: UIButton!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
                
        loginButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var socialButtonImage = UIImage(named: "SocialButton-\(Utility.sharedInstance.screenSizeH)h")
        var socialButtonImageView = UIImageView(image: socialButtonImage)
        socialButton = UIButton(frame: socialButtonImageView.frame)
        socialButton.frame.origin = CGPointMake(0, 0)
        socialButton.setImage(socialButtonImage, forState: UIControlState.Normal)
        socialButton.addTarget(self, action: Selector("askSuggestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(socialButton)
        
        var goodsButtonImage = UIImage(named: "GoodsButton-\(Utility.sharedInstance.screenSizeH)h")
        var goodsButtonImageView = UIImageView(image: goodsButtonImage)
        goodsButton = UIButton(frame: goodsButtonImageView.frame)
        goodsButton.frame.origin = CGPointMake(0, socialButtonImageView.frame.height + 5)
        goodsButton.setImage(goodsButtonImage, forState: UIControlState.Normal)
        goodsButton.addTarget(self, action: Selector("askSuggestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(goodsButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Utility.sharedInstance.user.anon == true {
            self.navigationItem.rightBarButtonItem = loginButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        Utility.sharedInstance.currentQuestion = nil
    }
    
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func askSuggestion(sender: AnyObject) {
        var catid: Int!
        var question: Question!
        
        if sender as! UIButton == socialButton {
            catid = 0
        } else if sender as! UIButton == goodsButton {
            catid = 1
        }
        
        question = Question(id: -1, questiondata: QuestionData(catid: catid, subcatid: -1, text: "", anon: Utility.sharedInstance.user.anon), date: 0, suggest: nil)
        Utility.sharedInstance.currentQuestion = question
        
        self.performSegueWithIdentifier("pushToQuestionViewController", sender: self)
    }
}


//
//  QuestionViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        
        var backgroundView: UIImageView!
        switch (Utility.sharedInstance.currentQuestion!.questiondata.catid) {
            case 0:
                backgroundView = UIImageView(image: UIImage(named: "SocialBackground"))
                break
            case 1:
                backgroundView = UIImageView(image: UIImage(named: "GoodsBackground"))
                break
            default:
                break
        }
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        
        var subcategoryView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        subcategoryView.backgroundColor = UIColor.whiteColor()
        subcategoryView.alpha = 0.8
        self.view.addSubview(subcategoryView)

        var leftImage = UIImageView(image: UIImage(named: "Hashtag"))
        leftImage.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        self.view.addSubview(leftImage)
        
        var anonButton = UIButton(frame: CGRect(x: 50, y: 10, width: 70, height: 70))
        if Utility.sharedInstance.user.anon == true {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))
            anonButton.setImage(UIImage(named: "AnonQuestionButton"), forState: UIControlState.Normal)
        } else {
            self.navigationItem.rightBarButtonItem = nil
            anonButton.setImage(UIImage(named: "RegisteredQuestionButton"), forState: UIControlState.Normal)
        }
        self.view.addSubview(anonButton)
        
        var subcategoryButton = UIButton(frame: CGRect(x: 60, y: 10, width: self.view.frame.width-200, height: 40))
        anonButton.setImage(UIImage(named: "WhiteBackgroundButton"), forState: UIControlState.Normal)
        //subcategoryView.addSubview(subcategoryButton)
    }
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func askSuggestionRequest() {
        var questiondata = QuestionData(catid: 1, subcatid: 1, text: "ciaone cosa vuol dire?", anon: true)
        
        Utility.sharedInstance.communicationHandler.askSuggestionRequest(questiondata) { (response) -> () in
            println("Ask Suggestion Request response: \(response)")
        }
    }
}
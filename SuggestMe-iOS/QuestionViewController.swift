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
    
    func askSuggestionRequest() {
        var questiondata = QuestionData(catid: 1, subcatid: 1, text: "ciaone cosa vuol dire?", anon: true)
        
        Utility.sharedInstance.communicationHandler.askSuggestionRequest(questiondata) { (response) -> () in
            println("Ask Suggestion Request response: \(response)")
        }
    }
}
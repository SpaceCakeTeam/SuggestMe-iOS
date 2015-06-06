//
//  QuestionViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var subcategoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default

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
        subcategoryView.alpha = 0.6
        self.view.addSubview(subcategoryView)

        var leftImage = UIImageView(image: UIImage(named: "Hashtag"))
        leftImage.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        self.view.addSubview(leftImage)
        
        var anonButton = UIButton(frame: CGRect(x: self.view.frame.width-60, y: 5, width: 50, height: 50))
        if Utility.sharedInstance.user.anon == true {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))
            anonButton.setImage(UIImage(named: "AnonQuestionButton"), forState: UIControlState.Normal)
        } else {
            self.navigationItem.rightBarButtonItem = nil
            anonButton.setImage(UIImage(named: "RegisteredQuestionButton"), forState: UIControlState.Normal)
        }
        self.view.addSubview(anonButton)
        
        var subcategoryButton = UIButton(frame: CGRect(x: leftImage.frame.width+30, y: 10, width: self.view.frame.width-(leftImage.frame.width+30 + anonButton.frame.width+30), height: 40))
        subcategoryButton.backgroundColor = UIColor.whiteColor()
        subcategoryButton.layer.cornerRadius = 5
        subcategoryButton.addTarget(self, action: Selector("showSubcategoryTableView:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(subcategoryButton)
        
        subcategoryTableView = UITableView(frame: CGRect(x: self.view.frame.width/3, y: subcategoryView.frame.height/2, width: self.view.frame.width/3, height: 200))
        subcategoryTableView.layer.cornerRadius = 10
        subcategoryTableView.backgroundColor = UIColor.whiteColor()
        subcategoryTableView.delegate = self
        subcategoryTableView.dataSource = self
        subcategoryTableView.backgroundColor = UIColor.clearColor()
        subcategoryTableView.rowHeight = 60
        subcategoryTableView.sectionFooterHeight = 0
        subcategoryTableView.sectionHeaderHeight = 0
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
    
    func showSubcategoryTableView(sender: AnyObject) {
        self.view.addSubview(subcategoryTableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utility.sharedInstance.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = subcategoryTableView.dequeueReusableCellWithIdentifier("subcategoryCell") as! QuestionCell
        //var subcategories = Utility.sharedInstance.categories[][indexPath.row]
        
        //cell.textSuggest.text = ""
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushToQuestionViewController", sender: self)
    }
}
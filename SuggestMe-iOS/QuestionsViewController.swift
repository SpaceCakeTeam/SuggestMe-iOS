//
//  QuestionsViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var loginButton: UIBarButtonItem!
    
    var suggestsTableView: UITableView!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        self.tabBarController?.delegate = self

        loginButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var backgroundView = UIImageView(image: UIImage(named: "QuestionsBackground-\(Utility.sharedInstance.screenSizeH)h"))
        self.view.addSubview(backgroundView)
        
        suggestsTableView = UITableView(frame: backgroundView.frame)
        suggestsTableView.delegate = self
        suggestsTableView.dataSource = self
        suggestsTableView.backgroundColor = UIColor.clearColor()
        suggestsTableView.separatorColor = UIColor.clearColor()
        suggestsTableView.rowHeight = 60
        suggestsTableView.registerClass(QuestionCell().classForCoder, forCellReuseIdentifier: "questionCellId")
        self.view.addSubview(suggestsTableView)

        self.tabBarController?.selectedIndex = 2
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Utility.sharedInstance.user.anon == true {
            self.navigationItem.rightBarButtonItem = loginButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        getSuggests()
    }
    
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    //MARK: UITableView Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utility.sharedInstance.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = suggestsTableView.dequeueReusableCellWithIdentifier("questionCellId") as! QuestionCell
        var question = Utility.sharedInstance.questions[indexPath.row]
        
        if question.questiondata.catid == 1 {
            cell.category.image = UIImage(named: "QuestionSocialIcon")
        } else if question.questiondata.catid == 2 {
            cell.category.image = UIImage(named: "QuestionGoodsIcon")
        }
        
        if question.suggest == nil {
            cell.status.image = UIImage(named: "QuestionPending")
        } else {
            cell.status.image = UIImage(named: "QuestionChecked")
        }
        
        for category in Utility.sharedInstance.categories {
            if category.id == question.questiondata.catid {
                for subcategory in category.subcategories {
                    if subcategory.id == question.questiondata.subcatid {
                        cell.textSuggest.text == subcategory.name
                        break
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Utility.sharedInstance.currentQuestion = Utility.sharedInstance.questions[indexPath.row]
        self.performSegueWithIdentifier("pushToQuestionViewController", sender: self)
    }
    
    //MARK: UITabBarController Delegates
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        var selectedNavigationController = viewController as! UINavigationController
        selectedNavigationController.popToRootViewControllerAnimated(false)
    }
    
    //MARK: Getting suggests
    func getSuggests() {
        var suggestsRequest = [Int]()
        for question in Utility.sharedInstance.questions {
            if question.suggest == nil {
                suggestsRequest.append(question.id)
            }
        }
        if suggestsRequest.count > 0 {
            Utility.sharedInstance.communicationHandler.getSuggestsRequest(suggestsRequest) { (response) -> () in
                println("Get Suggests Request response: \(response)")
                self.suggestsTableView.reloadData()
            }
        }
    }
}


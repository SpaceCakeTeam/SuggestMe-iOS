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
        if Utility.sharedInstance.screenSizeH == 736 {
            backgroundView.frame.size = self.view.frame.size
        }
        self.view.addSubview(backgroundView)
        
        suggestsTableView = UITableView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height))
        suggestsTableView.delegate = self
        suggestsTableView.dataSource = self
        suggestsTableView.backgroundColor = UIColor.clearColor()
        suggestsTableView.rowHeight = 60
        suggestsTableView.sectionFooterHeight = 0
        suggestsTableView.sectionHeaderHeight = 0
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
    
    
    //MARK: UIButton Actions
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    
    //MARK: UITableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utility.sharedInstance.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = suggestsTableView.dequeueReusableCellWithIdentifier("subcategoryCellId") as! QuestionCell
        
        var question = Utility.sharedInstance.questions[indexPath.row]
        
        if question.questiondata.catid == 0 {
            cell.category = UIImageView(image: UIImage(named: "QuestionSocialCategory"))
        } else if question.questiondata.catid == 1 {
            cell.category = UIImageView(image: UIImage(named: "QuestionGoodsCategory"))
        }
        
        if question.suggest == nil {
            cell.status = UIImageView(image: UIImage(named: "QuestionPending"))
        } else {
            cell.status = UIImageView(image: UIImage(named: "QuestionChecked"))
        }
        
        cell.textSuggest.text = Utility.sharedInstance.categories[question.questiondata.catid].subcategories[question.questiondata.subcatid].name
        
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
}


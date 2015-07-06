//
//  QuestionsViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate {
	
	var helpers = Helpers.shared

    var loginButton: UIBarButtonItem!    
    var suggestsTableView: UITableView!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		helpers.currentView = self.view         //CHECK

        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        self.tabBarController?.delegate = self

        loginButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var backgroundView = UIImageView(image: UIImage(named: "QuestionsBackground-\(helpers.screenHeight)h"))
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
        
        if helpers.user.anon == true {
            self.navigationItem.rightBarButtonItem = loginButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
		getSuggests() //CHECK
    }
    
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    //MARK: UITableView Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpers.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = suggestsTableView.dequeueReusableCellWithIdentifier("questionCellId") as! QuestionCell
        let question = helpers.questions[indexPath.row]
		
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
		
        for category in helpers.categories {
            if category.id == question.questiondata.catid {
                for subcategory in category.subcategories {
                    if subcategory.id == question.questiondata.subcatid {
						cell.setSuggestTitle(subcategory.name)
                        break
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
        helpers.currentQuestion = helpers.questions[indexPath.row]
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
        for question in helpers.questions {
            if question.suggest == nil {
                suggestsRequest.append(question.id)
            }
        }
        if suggestsRequest.count > 0 {
            helpers.communicationHandler.getSuggestsRequest(suggestsRequest) { (response) -> () in
				dispatch_sync(dispatch_get_main_queue(), { () -> Void in //CHECK
					self.suggestsTableView.reloadData()
				})
            }
        }
    }
}


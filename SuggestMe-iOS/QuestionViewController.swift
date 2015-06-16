//
//  QuestionViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var question: Question!
    var category: Category!
    
    var loginButton: UIBarButtonItem!
    var visibilityButton: UIButton!
    var anonButton: UIButton!
    var registeredButton: UIButton!
    var subcategoryButton: UIButton!
    
    var questionText: UITextField!
    
    var subcategoryTableView: UITableView!
    var arrowImageView: UIImageView!
    
    
    //MARK: UI methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
                
        loginButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))
        
        question = Utility.sharedInstance.currentQuestion
        category = Utility.sharedInstance.categories[question.questiondata.catid]

        var backgroundView: UIImageView!
        switch (question.questiondata.catid) {
            case 0:
                backgroundView = UIImageView(image: UIImage(named: "SocialBackground-\(Utility.sharedInstance.screenSizeH)h"))
                break
            case 1:
                backgroundView = UIImageView(image: UIImage(named: "GoodsBackground-\(Utility.sharedInstance.screenSizeH)h"))
                break
            default:
                break
        }
        backgroundView.frame.size = self.view.frame.size
        self.view.addSubview(backgroundView)
        
        var infoBarView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        infoBarView.backgroundColor = UIColor.whiteColor()
        infoBarView.alpha = 0.6
        self.view.addSubview(infoBarView)

        var hashtagImageView = UIImageView(image: UIImage(named: "Hashtag"))
        hashtagImageView.frame = CGRect(x: 10, y: 5, width: hashtagImageView.frame.width, height: hashtagImageView.frame.height)
        self.view.addSubview(hashtagImageView)
        
        var anonButtonImage = UIImage(named: "AnonButton")
        var anonButtonImageView = UIImageView(image: anonButtonImage)
        anonButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 5, width: anonButtonImageView.frame.width, height: anonButtonImageView.frame.height))
        anonButton.setImage(anonButtonImage, forState: UIControlState.Normal)
        anonButton.addTarget(self, action: Selector("setVisibilityQuestion:"), forControlEvents: UIControlEvents.TouchUpInside)

        var registeredButtonImage = UIImage(named: "RegisteredButton")
        var registeredButtonImageView = UIImageView(image: registeredButtonImage)
        registeredButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 5, width: registeredButtonImageView.frame.width, height: registeredButtonImageView.frame.height))
        registeredButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
        registeredButton.addTarget(self, action: Selector("setVisibilityQuestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        if Utility.sharedInstance.user.anon == true {
            visibilityButton = anonButton
        } else {
            visibilityButton = registeredButton
        }
        self.view.addSubview(visibilityButton)
        
        var subcategoryButtonImage = UIImage(named: "SubcategoryButton")
        var subcategoryButtonImageView = UIImageView(image: subcategoryButtonImage)
        subcategoryButton = UIButton(frame: CGRect(x: hashtagImageView.frame.width + 30, y: 10, width: subcategoryButtonImageView.frame.width, height: subcategoryButtonImageView.frame.height))
        subcategoryButton.setBackgroundImage(subcategoryButtonImage, forState: UIControlState.Normal)
        subcategoryButton.setTitle("Seleziona la sottocategoria", forState: UIControlState.Normal)
        subcategoryButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        subcategoryButton.addTarget(self, action: Selector("showSubcategories:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(subcategoryButton)
        
        subcategoryTableView = UITableView(frame: CGRect(x: hashtagImageView.frame.width + 30, y: infoBarView.frame.height, width: self.view.frame.width - (hashtagImageView.frame.width + visibilityButton.frame.width + 60), height: 200))
        subcategoryTableView.layer.cornerRadius = 10
        subcategoryTableView.backgroundColor = UIColor.whiteColor()
        subcategoryTableView.delegate = self
        subcategoryTableView.dataSource = self
        subcategoryTableView.rowHeight = 60
        subcategoryTableView.sectionFooterHeight = 0
        subcategoryTableView.sectionHeaderHeight = 0
        subcategoryTableView.registerClass(SubcategoryCell().classForCoder, forCellReuseIdentifier: "subcategoryCellId")
        
        arrowImageView = UIImageView(image: UIImage(named: "ArrowSubcategory"))
        arrowImageView.frame = CGRect(x: self.view.frame.width/2 - arrowImageView.frame.width/2, y: infoBarView.frame.height-10, width: arrowImageView.frame.width, height: arrowImageView.frame.height)
        arrowImageView.hidden = true
        self.view.addSubview(arrowImageView)
        
        var textFieldView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        textFieldView.backgroundColor = UIColor.whiteColor()
        textFieldView.clipsToBounds = true
        var bottomBorder = CALayer()
        bottomBorder.borderWidth = 0.5
        bottomBorder.backgroundColor = UIColor.blackColor().CGColor
        bottomBorder.frame = CGRectMake(0, textFieldView.frame.height - bottomBorder.borderWidth, textFieldView.frame.width, bottomBorder.borderWidth);
        textFieldView.layer.addSublayer(bottomBorder)
        self.view.addSubview(textFieldView)
        
        var sendButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: 0, width: 80, height: textFieldView.frame.height))
        sendButton.setTitle("Invia", forState: UIControlState.Normal)
        sendButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        sendButton.addTarget(self, action: Selector("askSuggestionRequest:"), forControlEvents: UIControlEvents.TouchUpInside)
        textFieldView.addSubview(sendButton)

        questionText = UITextField(frame: CGRect(x: 10, y: textFieldView.frame.height - 40, width: self.view.frame.width - sendButton.frame.width - 10, height: 30))
        questionText.layer.borderColor = UIColor.grayColor().CGColor
        questionText.layer.borderWidth = 1
        questionText.backgroundColor = UIColor.whiteColor()
        questionText.text = "  Fai la tua domanda"
        questionText.layer.cornerRadius = 10
        textFieldView.addSubview(questionText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        visibilityButton.removeFromSuperview()
        if Utility.sharedInstance.user.anon == true {
            self.navigationItem.rightBarButtonItem = loginButton
            visibilityButton = anonButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
            visibilityButton = registeredButton
        }
        self.view.addSubview(visibilityButton)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        Utility.sharedInstance.currentQuestion = nil
    }
    
    
    //MARK: UIButton Actions
    
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func setVisibilityQuestion(sender: AnyObject) {
        visibilityButton.removeFromSuperview()
        if sender as! UIButton == anonButton && Utility.sharedInstance.user.anon == false {
            visibilityButton = registeredButton
            question.questiondata.anon = false
        }
        if sender as! UIButton == registeredButton {
            visibilityButton = anonButton
            question.questiondata.anon = true
        }
        self.view.addSubview(visibilityButton)
    }

    func showSubcategories(sender: AnyObject) {
        if arrowImageView.hidden {
            arrowImageView.hidden = false
            self.view.addSubview(subcategoryTableView)
        } else {
            subcategoryTableView.removeFromSuperview()
            arrowImageView.hidden = true
        }
    }
    
    func askSuggestionRequest(sender: AnyObject) {
        question.questiondata.text = questionText.text
        
        Utility.sharedInstance.communicationHandler.askSuggestionRequest(question.questiondata) { (response) -> () in
            println("Ask Suggestion Request response: \(response)")
        }
    }
    
    
    //MARK: UITableView Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.subcategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = subcategoryTableView.dequeueReusableCellWithIdentifier("subcategoryCellId") as! SubcategoryCell
        
        cell.textCell.text = category.subcategories[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        subcategoryTableView.removeFromSuperview()
        arrowImageView.hidden = true
        question.questiondata.subcatid = category.subcategories[indexPath.row].id
        subcategoryButton.setTitle(category.subcategories[indexPath.row].name, forState: UIControlState.Normal)
    }
    
    
    //MARK: Touches methods
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}
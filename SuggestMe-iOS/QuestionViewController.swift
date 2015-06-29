//
//  QuestionViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var question: Question!
    var category: Category!
    
    var loginButton: UIBarButtonItem!
    
    var backgroundView: UIImageView!
    
    var visibilityButton: UIButton!
    var anonButtonImage = UIImage(named: "AnonButton")
    var registeredButtonImage = UIImage(named: "RegisteredButton")
    var subcategoryButton: UIButton!
    var subcategoryTableView: UITableView!

    var textFieldView: UIView!
    var questionText: UITextView!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
                
        loginButton = UIBarButtonItem(title: "Log In", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))
        
        question = Utility.sharedInstance.currentQuestion
        category = Utility.sharedInstance.categories[question.questiondata.catid-1]

        switch (question.questiondata.catid) {
            case 1:
                backgroundView = UIImageView(image: UIImage(named: "SocialBackground-\(Utility.sharedInstance.screenSizeH)h"))
                break
            case 2:
                backgroundView = UIImageView(image: UIImage(named: "GoodsBackground-\(Utility.sharedInstance.screenSizeH)h"))
                break
            default:
                break
        }
        self.view.addSubview(backgroundView)
        
        var infoBarView = UIView(frame: CGRect(x: 0, y: 0, width: backgroundView.frame.width, height: 50))
        infoBarView.backgroundColor = UIColor.whiteColor()
        infoBarView.alpha = 0.7
        self.view.addSubview(infoBarView)

        var hashtagImageView = UIImageView(image: UIImage(named: "Hashtag"))
        hashtagImageView.frame.origin = CGPointMake(5, 5)
        self.view.addSubview(hashtagImageView)
        
        var anonButtonImageView = UIImageView(image: anonButtonImage)
        var registeredButtonImageView = UIImageView(image: registeredButtonImage)
        visibilityButton = UIButton(frame: anonButtonImageView.frame)
        visibilityButton.frame.origin = CGPointMake(infoBarView.frame.width-anonButtonImageView.frame.width-5, 5)
        self.view.addSubview(visibilityButton)
        
        var subcategoryButtonImage = UIImage(named: "SubcategoryButton")
        var subcategoryButtonImageView = UIImageView(image: subcategoryButtonImage)
        subcategoryButton = UIButton(frame: subcategoryButtonImageView.frame)
        subcategoryButton.frame.origin = CGPointMake(infoBarView.frame.width/2-subcategoryButtonImageView.frame.width/2, 0)
        subcategoryButton.setBackgroundImage(subcategoryButtonImage, forState: UIControlState.Normal)
        subcategoryButton.setTitle(question.questiondata.text, forState: UIControlState.Normal)
        subcategoryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        subcategoryButton.titleLabel?.minimumScaleFactor = 1
        subcategoryButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(subcategoryButton)
        
        if question.id == -1 {
            visibilityButton.addTarget(self, action: Selector("setVisibilityQuestion:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            subcategoryButton.setTitle("Scegli...  ", forState: UIControlState.Normal)
            subcategoryButton.addTarget(self, action: Selector("showSubcategories:"), forControlEvents: UIControlEvents.TouchUpInside)

            subcategoryTableView = UITableView(frame: CGRect(x: subcategoryButton.frame.origin.x, y: subcategoryButton.frame.height, width: subcategoryButton.frame.width, height: subcategoryButton.frame.height*CGFloat(category.subcategories.count)))
            subcategoryTableView.backgroundColor = UIColor.whiteColor()
            subcategoryTableView.alpha = 0.7
            subcategoryTableView.separatorColor = UIColor.clearColor()
            subcategoryTableView.delegate = self
            subcategoryTableView.dataSource = self
            subcategoryTableView.rowHeight = 50
            subcategoryTableView.registerClass(SubcategoryCell().classForCoder, forCellReuseIdentifier: "subcategoryCellId")
            subcategoryTableView.hidden = true
            self.view.addSubview(subcategoryTableView)
            
            textFieldView = UIView(frame: CGRect(x: 0, y: backgroundView.frame.height-45, width: backgroundView.frame.width, height: 45))
            textFieldView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(textFieldView)
            var textFieldViewBorder = UIView(frame: CGRect(x: 0, y: backgroundView.frame.height-1, width: backgroundView.frame.width, height: 1))
            textFieldViewBorder.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview(textFieldViewBorder)
        
            var sendButton = UIButton(frame: CGRect(x: textFieldView.frame.width - 80, y: 0, width: 80, height: textFieldView.frame.height))
            sendButton.setTitle("Invia", forState: UIControlState.Normal)
            sendButton.setTitleColor(UIColor(red: 78.0/255.0, green: 133.0/255.0, blue: 248.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            sendButton.addTarget(self, action: Selector("askSuggestionRequest:"), forControlEvents: UIControlEvents.TouchUpInside)
            textFieldView.addSubview(sendButton)

            questionText = UITextView(frame: CGRect(x: 5, y: 7.5, width: textFieldView.frame.width-sendButton.frame.width - 5, height: 30))
            questionText.layer.borderColor = UIColor.lightGrayColor().CGColor
            questionText.layer.borderWidth = 1
            questionText.backgroundColor = UIColor.whiteColor()
            questionText.text = "Chiedi pure..."
            questionText.textColor = UIColor.lightGrayColor()
            questionText.layer.cornerRadius = 5
            
            questionText.delegate = self
            textFieldView.addSubview(questionText)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDisappear:"), name: UIKeyboardWillHideNotification, object: nil)
        }
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
        super.viewDidAppear(animated)
        
        if Utility.sharedInstance.user.anon == true {
            visibilityButton.setImage(anonButtonImage, forState: UIControlState.Normal)
        } else {
            visibilityButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
        }
        
        if question.id == -1 {
            questionText.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        questionText.resignFirstResponder()
    }
    
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func setVisibilityQuestion(sender: AnyObject) {
        if (Utility.sharedInstance.user.anon == false && question.questiondata.anon == true) {
            visibilityButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
            question.questiondata.anon = false
        } else {
            visibilityButton.setImage(anonButtonImage, forState: UIControlState.Normal)
            question.questiondata.anon = true
        }
    }

    func showSubcategories(sender: AnyObject) {
        if subcategoryTableView.hidden {
            subcategoryTableView.hidden = false
        } else {
            subcategoryTableView.hidden = true
        }
    }
    
    func askSuggestionRequest(sender: AnyObject) {
        question.questiondata.text = questionText.text
        if question.questiondata.subcatid != -1 && question.questiondata.text != "" {
            questionText.resignFirstResponder()
            self.view.addSubview(Utility.sharedInstance.setActivityIndicator(backgroundView.frame))
            Utility.sharedInstance.communicationHandler.askSuggestionRequest(question.questiondata) { (response) -> () in
                if response {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        } else {
            UIAlertView(title: "Error", message: "Message for error", delegate: self, cancelButtonTitle: "Close").show()
        }
    }
    
    //MARK: UITableView Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.subcategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = subcategoryTableView.dequeueReusableCellWithIdentifier("subcategoryCellId") as! SubcategoryCell
        cell.textCell.text = "\(category.subcategories[indexPath.row].name)  "
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        subcategoryTableView.hidden = true
        question.questiondata.subcatid = category.subcategories[indexPath.row].id
        subcategoryButton.setTitle("\(category.subcategories[indexPath.row].name)  ", forState: UIControlState.Normal)
    }
    
    //MARK: UITextView Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor = UIColor.blackColor()
        if textView.text == "Chiedi pure..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            textView.insertText("Chiedi pure...")
        }
    }
    
    //MARK: Touches methods
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        questionText.resignFirstResponder()
    }
    
    //MARK: Keyboard Notifications
    func keyboardChangeFrame(notification: NSNotification) {
        var userInfo: [NSObject: AnyObject] = notification.userInfo!
        var keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size
        moveTextField(keyboardSize!.height-self.tabBarController!.tabBar.frame.height)

    }
    
    func keyboardDisappear(notification: NSNotification) {
        moveTextField(0)
    }
    
    func moveTextField(size: CGFloat) {
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.textFieldView.frame.origin.y = self.backgroundView.frame.height - 45 - size
        })
    }
}
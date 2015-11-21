//
//  QuestionViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
	
	var helpers = Helpers.shared
	var navigationBarHeight: CGFloat!

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
    var sendButton: UIButton!
    var questionText: UITextView!
    var previousRect = CGRectZero
    
    var scrollBackgroundView: UIScrollView!
    
    var diffKFromOriginal = 0;
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationBarHeight = self.navigationController!.navigationBar.frame.height
		self.view.frame.size = CGSizeMake(helpers.screenWidth, helpers.screenHeightNoStatus)
		helpers.currentView = self.view
		helpers.currentViewFrame = CGRectMake(0, 0, helpers.screenWidth, (helpers.screenHeightNoStatus-navigationBarHeight)/2)
		
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Indietro".localized, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("back:"))
        loginButton = UIBarButtonItem(title: "Log In".localized, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))
        
        question = helpers.currentQuestion
        category = helpers.categories[question.questiondata.catid-1]

        switch (question.questiondata.catid) {
            case 1:
                backgroundView = UIImageView(image: UIImage(named: "GoodsBackground-\(Int(helpers.screenHeight))h"))
                break
            case 2:
                backgroundView = UIImageView(image: UIImage(named: "SocialBackground-\(Int(helpers.screenHeight))h"))
                break
            default:
                break
        }
        self.view.addSubview(backgroundView)
        
        let infoBarView = UIView(frame: CGRectMake(0, 0, backgroundView.frame.width, 50))
        infoBarView.backgroundColor = UIColor.whiteColor()
        infoBarView.alpha = 0.7

        let hashtagImageView = UIImageView(image: UIImage(named: "Hashtag"))
        hashtagImageView.frame.origin = CGPointMake(7, 5)
        
        let anonButtonImageView = UIImageView(image: anonButtonImage)
        visibilityButton = UIButton(frame: anonButtonImageView.frame)
        visibilityButton.frame.origin = CGPointMake(infoBarView.frame.width-anonButtonImageView.frame.width-5, 5)
        
        let subcategoryButtonImage = UIImage(named: "SubcategoryButton")
        let subcategoryButtonImageView = UIImageView(image: subcategoryButtonImage)
        subcategoryButton = UIButton(frame: subcategoryButtonImageView.frame)
        subcategoryButton.frame.origin = CGPointMake(infoBarView.frame.width/2-subcategoryButtonImageView.frame.width/2, 0)
        subcategoryButton.setBackgroundImage(subcategoryButtonImage, forState: UIControlState.Normal)
		for category in helpers.categories {
			if category.id == question.questiondata.catid {
				for subcategory in category.subcategories {
					if subcategory.id == question.questiondata.subcatid {
						subcategoryButton.setTitle(subcategory.name.localized, forState: UIControlState.Normal)
						break
					}
				}
			}
		}
        subcategoryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        subcategoryButton.titleLabel?.minimumScaleFactor = 1
        subcategoryButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        if question.id == -1 {
            visibilityButton.addTarget(self, action: Selector("setVisibilityQuestion:"), forControlEvents: UIControlEvents.TouchUpInside)
			
			let titleText = "Scegli...".localized
            subcategoryButton.setTitle("\(titleText)  ", forState: UIControlState.Normal)
			subcategoryButton.titleLabel!.font = UIFont(name: helpers.getAppFont(), size: 18)
            subcategoryButton.addTarget(self, action: Selector("showSubcategories:"), forControlEvents: UIControlEvents.TouchUpInside)

            subcategoryTableView = UITableView(frame: CGRectMake(subcategoryButton.frame.origin.x, subcategoryButton.frame.height, subcategoryButton.frame.width, subcategoryButton.frame.height*CGFloat(category.subcategories.count)))
            subcategoryTableView.backgroundColor = UIColor.whiteColor()
            subcategoryTableView.alpha = 0.7
            subcategoryTableView.separatorColor = UIColor.clearColor()
            subcategoryTableView.delegate = self
            subcategoryTableView.dataSource = self
            subcategoryTableView.rowHeight = 50
            subcategoryTableView.registerClass(SubcategoryCell().classForCoder, forCellReuseIdentifier: "subcategoryCellId")
            subcategoryTableView.hidden = true
            self.view.addSubview(subcategoryTableView)
            
            textFieldView = UIView(frame: CGRectMake(0, backgroundView.frame.height-45, backgroundView.frame.width, 45))
            textFieldView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(textFieldView)
            let textFieldViewBorder = UIView(frame: CGRectMake(0, backgroundView.frame.height-1, backgroundView.frame.width, 1))
            textFieldViewBorder.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview(textFieldViewBorder)
        
            sendButton = UIButton(frame: CGRectMake(textFieldView.frame.width-80, textFieldView.frame.height-50, 80, 50))
            sendButton.setTitle("Invia".localized, forState: UIControlState.Normal)
			sendButton.titleLabel!.font = UIFont(name: helpers.getAppFont(), size: 20)
            sendButton.setTitleColor(UIColor(red: 78.0/255.0, green: 133.0/255.0, blue: 248.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
            sendButton.addTarget(self, action: Selector("askSuggestionRequest:"), forControlEvents: UIControlEvents.TouchUpInside)
            textFieldView.addSubview(sendButton)

            questionText = UITextView(frame: CGRectMake(5, 7.5, textFieldView.frame.width-sendButton.frame.width-5, 30))
            questionText.layer.borderColor = UIColor.lightGrayColor().CGColor
            questionText.layer.borderWidth = 1
            questionText.backgroundColor = UIColor.whiteColor()
            questionText.text = "Chiedi pure...".localized
			questionText.font = UIFont(name: helpers.getAppFont(), size: 15)
            questionText.textColor = UIColor.lightGrayColor()
            questionText.layer.cornerRadius = 5
            questionText.delegate = self
			
			textFieldView.addSubview(questionText)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardChangeFrame:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDisappear:"), name: UIKeyboardWillHideNotification, object: nil)
		} else {
            scrollBackgroundView = UIScrollView(frame: CGRectMake(0, 0, helpers.screenWidth, backgroundView.frame.height))
            scrollBackgroundView.showsVerticalScrollIndicator = false
            self.view.addSubview(scrollBackgroundView)
            
			let requestTextArrow = UIImageView(image: UIImage(named: "RequestSuggestion"))
			requestTextArrow.frame.origin = CGPointMake(helpers.screenWidth-15-requestTextArrow.frame.width, infoBarView.frame.height+20)
			scrollBackgroundView.addSubview(requestTextArrow)
			
			let requestText = Label(frame: CGRectMake(10, infoBarView.frame.height+20, helpers.screenWidth-20-requestTextArrow.frame.width, 0))
			requestText.numberOfLines = 0
			requestText.text = question.questiondata.text
			requestText.font = UIFont(name:helpers.getAppFont(), size: 15)
			requestText.textAlignment = NSTextAlignment.Right
			requestText.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
			requestText.sizeToFit()
			requestText.layer.masksToBounds = true
			requestText.layer.cornerRadius = 5
			requestText.frame.size = CGSizeMake(helpers.screenWidth-20-requestTextArrow.frame.width, requestText.frame.height+10)
			scrollBackgroundView.addSubview(requestText)
		
			if question.suggest != nil {
				let responseTextArrow = UIImageView(image: UIImage(named: "ResponseSuggestion"))
				responseTextArrow.frame.origin = CGPointMake(10, infoBarView.frame.height+20+requestText.frame.height+20)
				scrollBackgroundView.addSubview(responseTextArrow)
				
				let responseText = Label(frame: CGRectMake(10+responseTextArrow.frame.width-5, infoBarView.frame.height+20+requestText.frame.height+20, helpers.screenWidth-20-responseTextArrow.frame.width, 0))
				responseText.numberOfLines = 0
				responseText.text = question.suggest?.text
				responseText.font = UIFont(name:helpers.getAppFont(), size: 15)
				responseText.textAlignment = NSTextAlignment.Left
				responseText.textColor = UIColor.whiteColor()
				responseText.backgroundColor = UIColor(red: 59.0/255.0, green: 87.0/255.0, blue: 157.0/255.0, alpha: 1.0)
				responseText.sizeToFit()
				responseText.layer.masksToBounds = true
				responseText.layer.cornerRadius = 5
				responseText.frame.size = CGSizeMake(helpers.screenWidth-20-requestTextArrow.frame.width, responseText.frame.height+10)
				scrollBackgroundView.addSubview(responseText)
                scrollBackgroundView.contentSize = CGSizeMake(scrollBackgroundView.frame.width,infoBarView.frame.height+20 + requestText.frame.height + responseText.frame.height+navigationBarHeight)
            } else {
                scrollBackgroundView.contentSize = CGSizeMake(scrollBackgroundView.frame.width,infoBarView.frame.height+20 + requestText.frame.height)
            }
		}
        
        self.view.addSubview(infoBarView)
        self.view.addSubview(hashtagImageView)
        self.view.addSubview(visibilityButton)
        self.view.addSubview(subcategoryButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		helpers.user.anon == true ? self.navigationItem.setRightBarButtonItem(loginButton, animated: false) : self.navigationItem.setRightBarButtonItem(nil, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if question.questiondata.text != "" {
            question.questiondata.anon == true ? visibilityButton.setImage(anonButtonImage, forState: UIControlState.Normal) : visibilityButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
        } else {
            helpers.user.anon == true ? visibilityButton.setImage(anonButtonImage, forState: UIControlState.Normal) : visibilityButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
        }
        
        if question.id == -1 {
            questionText.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
		helpers.currentQuestion = nil
    }
    
    //MARK: UIButton Actions
	func back(sender: AnyObject) {
		self.navigationController!.popToRootViewControllerAnimated(true)
	}
	
	func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func setVisibilityQuestion(sender: AnyObject) {
        if (helpers.user.anon == false && question.questiondata.anon == true) {
            visibilityButton.setImage(registeredButtonImage, forState: UIControlState.Normal)
            question.questiondata.anon = false
        } else {
            visibilityButton.setImage(anonButtonImage, forState: UIControlState.Normal)
            question.questiondata.anon = true
        }
    }

    func showSubcategories(sender: AnyObject) {
        self.view.addSubview(subcategoryTableView)
        if subcategoryTableView.hidden {
            subcategoryTableView.hidden = false
            questionText.resignFirstResponder()
        } else {
            subcategoryTableView.hidden = true
            questionText.becomeFirstResponder()
        }
    }
    
    func askSuggestionRequest(sender: AnyObject) {
        if question.questiondata.subcatid != -1 && questionText.text != "" && helpers.checkQuestionText(questionText.text) {
            question.questiondata.text = questionText.text
            helpers.communicationHandler.askSuggestionRequest(question.questiondata) { (response) -> () in
                if response {
					self.helpers.pushToQuestionsView = true
					dispatch_sync(dispatch_get_main_queue(), { () -> Void in
						self.navigationController!.popToRootViewControllerAnimated(true)
					})
				}
            }
		} else {
			helpers.showAlert(1)
		}
    }
    
    //MARK: UITableView Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.subcategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = subcategoryTableView.dequeueReusableCellWithIdentifier("subcategoryCellId") as! SubcategoryCell
        cell.textCell.text = "\(category.subcategories[indexPath.row].name)  "
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        subcategoryTableView.hidden = true
        questionText.becomeFirstResponder()
        question.questiondata.subcatid = category.subcategories[indexPath.row].id
		let titleText = category.subcategories[indexPath.row].name.localized
        subcategoryButton.setTitle("\(titleText)  ", forState: UIControlState.Normal)
    }
    
    //MARK: UITextView Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor = UIColor.blackColor()
        if textView.text == "Chiedi pure...".localized {
            textView.text = ""
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let pos = textView.endOfDocument
        let currentRect = textView.caretRectForPosition(pos)
        if(currentRect.origin.y > previousRect.origin.y && textFieldView.frame.height < backgroundView.frame.height/4) {
            textFieldView.frame.origin.y = textFieldView.frame.origin.y-8;
            textFieldView.frame.size.height = textFieldView.frame.height+8;
            textView.frame.size.height = textView.frame.height+8;
            sendButton.frame.origin.y = sendButton.frame.origin.y+8;
            diffKFromOriginal += 8;
        }
        previousRect = currentRect
    }
    
    //MARK: Touches methods
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if question.id == -1{
            questionText.resignFirstResponder()
        }
    }
    
    //MARK: Keyboard Notifications
    func keyboardChangeFrame(notification: NSNotification) {
        var userInfo: [NSObject: AnyObject] = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
        moveTextField(keyboardSize!.height-self.tabBarController!.tabBar.frame.height)
    }
    
    func keyboardDisappear(notification: NSNotification) {
        moveTextField(0);
    }
    
    func moveTextField(size: CGFloat) {
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.textFieldView.frame.origin.y = self.backgroundView.frame.height-45-CGFloat(self.diffKFromOriginal)-size
        })
    }
}

class Label: UILabel {
	override func drawTextInRect(rect: CGRect) {
		super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)))
	}
}
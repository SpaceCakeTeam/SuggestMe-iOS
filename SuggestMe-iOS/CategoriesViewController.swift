//
//  CategoriesViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

class CategoriesViewController: UIViewController {

	var helpers = Helpers.shared
	var navigationBarHeight: CGFloat!
	var tabBarHeight: CGFloat!

    var loginButton: UIBarButtonItem!
    var socialButton: UIButton!
    var goodsButton: UIButton!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationBarHeight = self.navigationController!.navigationBar.frame.height
		tabBarHeight = self.tabBarController!.tabBar.frame.height
		self.view.frame.size = CGSizeMake(helpers.screenWidth, helpers.screenHeightNoStatus)
		helpers.currentView = self.view
		helpers.currentViewFrame = CGRectMake(0, 0, helpers.screenWidth, helpers.screenHeightNoStatus-navigationBarHeight-tabBarHeight)
		
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TitleNavigationBar"))
        UIApplication.sharedApplication().statusBarStyle = .Default
                
        loginButton = UIBarButtonItem(title: "Log In".localized, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        var socialButtonImage = UIImage(named: "SocialButton-\(Int(helpers.screenHeight))h")
        var socialButtonImageView = UIImageView(image: socialButtonImage)
        socialButton = UIButton(frame: socialButtonImageView.frame)
        socialButton.frame.origin = CGPointMake(0, 0)
        socialButton.setImage(socialButtonImage, forState: UIControlState.Normal)
        socialButton.addTarget(self, action: Selector("askSuggestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(socialButton)
        
        var goodsButtonImage = UIImage(named: "GoodsButton-\(Int(helpers.screenHeight))h")
        var goodsButtonImageView = UIImageView(image: goodsButtonImage)
        goodsButton = UIButton(frame: goodsButtonImageView.frame)
        goodsButton.frame.origin = CGPointMake(0, socialButtonImageView.frame.height + 5)
        goodsButton.setImage(goodsButtonImage, forState: UIControlState.Normal)
        goodsButton.addTarget(self, action: Selector("askSuggestion:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(goodsButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		helpers.user.anon == true ? self.navigationItem.setRightBarButtonItem(loginButton, animated: false) : self.navigationItem.setRightBarButtonItem(nil, animated: false)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if helpers.pushToQuestionsView == true {
			helpers.pushToQuestionsView = false
			self.tabBarController!.selectedIndex = 0
		}
	}
	
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
    
    func askSuggestion(sender: AnyObject) {
        var catid: Int!
        var question: Question!
        
        if sender as! UIButton == socialButton {
            catid = 1
        } else if sender as! UIButton == goodsButton {
            catid = 2
        }
        
        question = Question(id: -1, questiondata: QuestionData(catid: catid, subcatid: -1, text: "", anon: helpers.user.anon), date: 0, suggest: nil)
        helpers.currentQuestion = question
        
        self.performSegueWithIdentifier("pushToQuestionViewController", sender: self)
    }
}


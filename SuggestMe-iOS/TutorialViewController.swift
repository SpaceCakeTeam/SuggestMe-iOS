//
//  TutorialViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
	
	var helpers = Helpers.shared
    var isUserSetted = false
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var tutorialViews: [UIImageView]!
    var currentFrame: CGRect!

    var loginSocialButtons: UIButton!
    var loginAnonButton: UIButton!
    
    //MARK: UI methods
    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.frame.size = CGSizeMake(helpers.screenWidth, helpers.screenHeightNoStatus)
		helpers.currentView = self.view
		helpers.currentViewFrame = CGRectMake(0, 0, helpers.screenWidth, helpers.screenHeight)
		
		isUserSetted = helpers.setDataUser()

        if !isUserSetted {
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            self.view.backgroundColor = UIColor.blackColor()

            var background1 = UIImageView(image: UIImage(named: "TutorialBackgroundPage1-\(Int(helpers.screenHeight))h"))
            var background2 = UIImageView(image: UIImage(named: "TutorialBackgroundPage2-\(Int(helpers.screenHeight))h"))
            var background3 = UIImageView(image: UIImage(named: "TutorialBackgroundPage3-\(Int(helpers.screenHeight))h"))
            var background4 = UIImageView(image: UIImage(named: "TutorialBackgroundPage4-\(Int(helpers.screenHeight))h"))
            var background5 = UIImageView(image: UIImage(named: "TutorialBackgroundPage5-\(Int(helpers.screenHeight))h"))
            
            currentFrame = CGRectMake(0, helpers.screenHeightNoStatus/2-self.view.frame.height/2, helpers.screenWidth, self.view.frame.height)
            
            scrollView = UIScrollView(frame: CGRectMake(0, helpers.screenHeight-helpers.screenHeightNoStatus, helpers.screenWidth, helpers.screenHeightNoStatus))
            scrollView.delegate = self
            scrollView.pagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
        
            pageControl = UIPageControl(frame: CGRectMake(0, helpers.screenHeightNoStatus, helpers.screenWidth, helpers.statusBarHeight))
			pageControl.frame.origin = CGPointMake(self.view.frame.width/2-pageControl.frame.width/2, pageControl.frame.origin.y)
			pageControl.numberOfPages = 5
            pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
            
            tutorialViews = [background1, background2, background3, background4, background5]
            
            for index in 0..<tutorialViews.count {
                currentFrame.origin.x = scrollView.frame.width*CGFloat(index)
                
                var currentView = tutorialViews[index]
                currentView.frame = currentFrame
                scrollView.addSubview(currentView)

                if index == tutorialViews.count-1 {
                    var loginSocialImageView = UIImageView(image: UIImage(named: "LoginSocialButtons-\(Int(helpers.screenHeight))h"))
                    loginSocialImageView.frame.origin = CGPointMake(currentFrame.origin.x + (currentFrame.width/2 - loginSocialImageView.frame.width/2), currentFrame.height/2 - loginSocialImageView.frame.height/2)
                    scrollView.addSubview(loginSocialImageView)
                    
                    loginSocialButtons = UIButton(frame: loginSocialImageView.frame)
                    loginSocialButtons.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    scrollView.addSubview(loginSocialButtons)
                   
                    var loginNotNowImage = UIImage(named: "LoginNotNowButton-\(Int(helpers.screenHeight))h")
                    var loginNotNowImageView = UIImageView(image: loginNotNowImage)
                    loginAnonButton = UIButton(frame: loginNotNowImageView.frame)
                    loginAnonButton.frame.origin = CGPointMake(currentFrame.origin.x + (currentFrame.width/2-loginNotNowImageView.frame.width/2), currentFrame.height-currentFrame.height/4-loginNotNowImageView.frame.height/2)
                    loginAnonButton.setImage(loginNotNowImage, forState: UIControlState.Normal)
                    loginAnonButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    scrollView.addSubview(loginAnonButton)
                }
            }
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(tutorialViews.count), scrollView.frame.height)
            self.view.addSubview(scrollView)
            self.view.addSubview(pageControl)
        }
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if isUserSetted {
            self.performSegueWithIdentifier("presentHomeTabBarController", sender: self)
        }
    }
    
    //MARK: PageControl and UIScrollView methods
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage)*scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
        pageControl.currentPage = Int(pageNumber)
    }
    
    //MARK: UIButton Actions
    func login(sender: AnyObject) {
		if sender as! UIButton == loginSocialButtons {
            helpers.user.anon = false
			//helpers.getFacebookAccount() select with frame of touch //TODO
			//helpers.getTwitterAccount() select with frame of touch //TODO
			helpers.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com") //TODO
        } else if sender as! UIButton == loginAnonButton {
            helpers.user.anon = true
        }
        
        helpers.communicationHandler.registrationRequest() { (response) -> () in
            if response {
				dispatch_sync(dispatch_get_main_queue(), { () -> Void in
					self.performSegueWithIdentifier("presentHomeTabBarController", sender: self)
				})
			}
        }
    }
    
    //MARK: Touches methods
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		//get position of touch //TODO
    }
}
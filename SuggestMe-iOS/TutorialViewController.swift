//
//  TutorialViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    var isUserSetted = false
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var tutorialViews: [UIImageView]!
    var currentFrame: CGRect = CGRectMake(0, 0, 0, 0)

    var firstTutorialView = UIImageView(image: UIImage(named: "TutorialBackgroundPage1"))
    var secondTutorialView = UIImageView(image: UIImage(named: "TutorialBackgroundPage2"))
    var thirdTutorialView = UIImageView(image: UIImage(named: "TutorialBackgroundPage3"))
    var fourthTutorialView = UIImageView(image: UIImage(named: "TutorialBackgroundPage4"))
    var fiveTutorialView = UIImageView(image: UIImage(named: "TutorialBackgroundPage5"))
    
    var loginFacebookButton: UIButton!
    var loginTwitterButton: UIButton!
    var loginAnonButton: UIButton!
    
    
    //MARK: UI methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: Setting user
        
        isUserSetted = Utility.sharedInstance.setUser()

        if !isUserSetted {
            scrollView = UIScrollView(frame: self.view.frame)
            scrollView.delegate = self
            scrollView.pagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
        
            pageControl = UIPageControl(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.height-30, width: self.view.frame.width, height: 30))
            pageControl.numberOfPages = 5
            pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        
            tutorialViews = [firstTutorialView, secondTutorialView, thirdTutorialView, fourthTutorialView, fiveTutorialView]
            for index in 0..<tutorialViews.count {
                currentFrame.origin.x = scrollView.frame.width * CGFloat(index)
                currentFrame.size = scrollView.frame.size
            
                var currentView = tutorialViews[index]
                currentView.frame = currentFrame
                scrollView.addSubview(currentView)

                if index == tutorialViews.count-1 {
                    var loginFacebookImageView = UIImageView(image: UIImage(named: "LoginFacebookButton"))
                    loginFacebookButton = UIButton(frame: CGRect(x: currentFrame.origin.x + (self.view.frame.width/2-loginFacebookImageView.frame.width/2), y: self.view.frame.height/2-loginFacebookImageView.frame.height/2-3, width: loginFacebookImageView.frame.width, height: loginFacebookImageView.frame.height))
                    loginFacebookButton.setImage(UIImage(named: "LoginFacebookButton"), forState: UIControlState.Normal)
                    loginFacebookButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    
                    var shapeLayer = CAShapeLayer()
                    var path = CGPathCreateMutable()
                    shapeLayer.path = path;
                    CGPathMoveToPoint(path, nil, 0, CGRectGetHeight(loginFacebookButton.frame));
                    CGPathAddLineToPoint(path, nil, CGRectGetWidth(loginFacebookButton.frame), 0);
                    CGPathAddLineToPoint(path, nil, CGRectGetWidth(loginFacebookButton.frame), CGRectGetHeight(loginFacebookButton.frame));
                    CGPathCloseSubpath(path);
                    shapeLayer.path = path;
                    loginFacebookButton.layer.masksToBounds = true;
                    loginFacebookButton.layer.mask = shapeLayer;
                    
                    
                    
                    
                    var loginTwitterImageView = UIImageView(image: UIImage(named: "LoginTwitterButton"))
                    loginTwitterButton = UIButton(frame: CGRect(x: currentFrame.origin.x + (self.view.frame.width/2-loginTwitterImageView.frame.width/2), y: self.view.frame.height/2-loginTwitterImageView.frame.height/2+3, width: loginTwitterImageView.frame.width, height: loginTwitterImageView.frame.height))
                    loginTwitterButton.setImage(UIImage(named: "LoginTwitterButton"), forState: UIControlState.Normal)
                    loginTwitterButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    
                    var loginNotNowImageView = UIImageView(image: UIImage(named: "LoginNotNowButton"))
                    loginAnonButton = UIButton(frame: CGRect(x: currentFrame.origin.x + (self.view.frame.width/2-loginNotNowImageView.frame.width/2), y: self.view.frame.height-self.view.frame.height/4-loginNotNowImageView.frame.height/2, width: loginNotNowImageView.frame.width, height: loginNotNowImageView.frame.height))
                    loginAnonButton.setImage(UIImage(named: "LoginNotNowButton"), forState: UIControlState.Normal)
                    loginAnonButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                

                    scrollView.addSubview(loginTwitterButton)

                    scrollView.addSubview(loginFacebookButton)

                    scrollView.addSubview(loginAnonButton)
                }
            }
        
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(tutorialViews.count), scrollView.frame.size.height)
            self.view.addSubview(scrollView)
            self.view.addSubview(pageControl)
            
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isUserSetted {
            self.performSegueWithIdentifier("presentHomeTabBarController", sender: self)
        }
    }
    
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
        pageControl.currentPage = Int(pageNumber)
    }
    
    func setActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.addSubview(Utility.sharedInstance.setActivityIndicator(self.view.frame))
        }
    }
    

    //MARK: Login method
    
    func login(sender: AnyObject) {
        setActivityIndicator()
        
        if sender as! UIButton == loginFacebookButton {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getFacebookAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        } else if sender as! UIButton == loginTwitterButton {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getTwitterAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        } else if sender as! UIButton == loginAnonButton {
            Utility.sharedInstance.user.anon = true
        }
        
        Utility.sharedInstance.communicationHandler.registrationRequest() { (response) -> () in
            println("Registration Request response: \(response)")
            if response {
                self.performSegueWithIdentifier("presentHomeTabBarController", sender: self)
            }
            Utility.sharedInstance.activityIndicatorView.removeFromSuperview()
        }
    }
}
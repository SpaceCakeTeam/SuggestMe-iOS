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
                    loginFacebookButton = UIButton(frame: CGRect(x: currentFrame.origin.x, y: currentFrame.size.height/2-self.view.frame.width/4, width: self.view.frame.width, height: self.view.frame.width/2))
                    loginFacebookButton.setImage(UIImage(named: "LoginFacebookButton"), forState: UIControlState.Normal)
                    loginFacebookButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                    loginTwitterButton = UIButton(frame: CGRect(x: currentFrame.origin.x, y: currentFrame.size.height/2-self.view.frame.width/4+5, width: self.view.frame.width, height: self.view.frame.width/2))
                    loginTwitterButton.setImage(UIImage(named: "LoginTwitterButton"), forState: UIControlState.Normal)
                    loginTwitterButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    
                    loginAnonButton = UIButton(frame: CGRect(x: currentFrame.origin.x, y: currentFrame.size.height-200, width: self.view.frame.width, height: 100))
                    loginAnonButton.setTitle("Non ora", forState: UIControlState.Normal)
                    loginAnonButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                    scrollView.addSubview(loginFacebookButton)
                    scrollView.addSubview(loginTwitterButton)
                    scrollView.addSubview(loginAnonButton)
                }
            }
        
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(tutorialViews.count), scrollView.frame.size.height)
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
            self.view.addSubview(Utility.sharedInstance.setActivityIndicator(self.view.frame, text: "logging in..."))
        }
    }
    

    //MARK: Login method
    
    func login(sender: AnyObject) {
        setActivityIndicator()
        
        if sender as! UIButton == loginFacebookButton {
            Utility.sharedInstance.user.anon = false
            //social methods
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        } else if sender as! UIButton == loginTwitterButton {
            Utility.sharedInstance.user.anon = false
            //social methods
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
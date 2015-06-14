//
//  TutorialViewController.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 20/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    let screenSize = Int(UIScreen.mainScreen().bounds.size.height)
    
    var isUserSetted = false
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var tutorialViews: [UIImageView]!
    var currentFrame: CGRect = CGRectMake(0, 0, 0, 0)

    var loginFacebookButton: UIButton!
    var loginTwitterButton: UIButton!
    var loginAnonButton: UIButton!
    
    
    //MARK: UI methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //MARK: Setting user
        
        isUserSetted = Utility.sharedInstance.setUser()

        if !isUserSetted {
            UIApplication.sharedApplication().statusBarStyle = .LightContent

            scrollView = UIScrollView(frame: self.view.frame)
            scrollView.delegate = self
            scrollView.pagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
        
            pageControl = UIPageControl(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.height-30, width: self.view.frame.width, height: 30))
            pageControl.numberOfPages = 5
            pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        
            tutorialViews = [UIImageView(image: UIImage(named: "TutorialBackgroundPage1-\(screenSize)h")), UIImageView(image: UIImage(named: "TutorialBackgroundPage2-\(screenSize)h")), UIImageView(image: UIImage(named: "TutorialBackgroundPage3-\(screenSize)h")), UIImageView(image: UIImage(named: "TutorialBackgroundPage4-\(screenSize)h")), UIImageView(image: UIImage(named: "TutorialBackgroundPage5-\(screenSize)h"))]
            
            for index in 0..<tutorialViews.count {
                currentFrame.origin.x = scrollView.frame.width * CGFloat(index)
                currentFrame.size = scrollView.frame.size
            
                var currentView = tutorialViews[index]
                currentView.frame = currentFrame
                scrollView.addSubview(currentView)

                if index == tutorialViews.count-1 {
                    var loginFacebookImage = UIImage(named: "LoginFacebookButton")
                    var loginFacebookImageView = UIImageView(image: loginFacebookImage)
                    loginFacebookButton = UIButton(frame: CGRect(x: currentFrame.origin.x + (self.view.frame.width/2 - loginFacebookImageView.frame.width/2), y: self.view.frame.height/2 - loginFacebookImageView.frame.height/2-2, width: loginFacebookImageView.frame.width, height: loginFacebookImageView.frame.height))
                    loginFacebookButton.setImage(loginFacebookImage, forState: UIControlState.Normal)
                    loginFacebookButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    scrollView.addSubview(loginFacebookButton)
                    
                    var loginTwitterImage = UIImage(named: "LoginTwitterButton")
                    var loginTwitterImageView = UIImageView(image: loginTwitterImage)
                    loginTwitterButton = UIButton(frame: CGRect(x: currentFrame.origin.x + (self.view.frame.width/2 - loginTwitterImageView.frame.width/2), y: self.view.frame.height/2 - loginTwitterImageView.frame.height/2+2, width: loginTwitterImageView.frame.width, height: loginTwitterImageView.frame.height))
                    loginTwitterButton.setImage(loginTwitterImage, forState: UIControlState.Normal)
                    loginTwitterButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
                    scrollView.addSubview(loginTwitterButton)
                   
                    var loginNotNowImage = UIImage(named: "LoginNotNowButton")
                    var loginNotNowImageView = UIImageView(image: loginNotNowImage)
                    loginAnonButton = UIButton(frame: CGRect(x: currentFrame.origin.x + (self.view.frame.width/2-loginNotNowImageView.frame.width/2), y: self.view.frame.height-self.view.frame.height/4-loginNotNowImageView.frame.height/2, width: loginNotNowImageView.frame.width, height: loginNotNowImageView.frame.height))
                    loginAnonButton.setImage(loginNotNowImage, forState: UIControlState.Normal)
                    loginAnonButton.addTarget(self, action: Selector("login:"), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    
    //MARK: PageControl and UIScrollView methods
    
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width);
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    //MARK: UIButton Actions
    
    func login(sender: AnyObject) {
        var button = sender as! UIButton
        button.enabled = false
        self.view.addSubview(Utility.sharedInstance.setActivityIndicator(self.view.frame))
        
        if button == loginFacebookButton {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getFacebookAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        } else if button == loginTwitterButton {
            Utility.sharedInstance.user.anon = false
            //Utility.sharedInstance.getTwitterAccount()
            Utility.sharedInstance.user.userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")
        } else if button == loginAnonButton {
            Utility.sharedInstance.user.anon = true
        }
        
        Utility.sharedInstance.communicationHandler.registrationRequest() { (response) -> () in
            println("Registration Request response: \(response)")
            if response {
                self.performSegueWithIdentifier("presentHomeTabBarController", sender: self)
            } else {
                button.enabled = true
            }
        }
    }
    
    
    //MARK: Touches methods
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //get position of touch
    }
}
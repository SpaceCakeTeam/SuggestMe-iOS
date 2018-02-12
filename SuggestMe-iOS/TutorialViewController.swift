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

            let background1 = UIImageView(image: UIImage(named: "TutorialBackgroundPage1-\(Int(helpers.screenHeight))h"))
            let background2 = UIImageView(image: UIImage(named: "TutorialBackgroundPage2-\(Int(helpers.screenHeight))h"))
            let background3 = UIImageView(image: UIImage(named: "TutorialBackgroundPage3-\(Int(helpers.screenHeight))h"))
            let background4 = UIImageView(image: UIImage(named: "TutorialBackgroundPage4-\(Int(helpers.screenHeight))h"))
            let background5 = UIImageView(image: UIImage(named: "TutorialBackgroundPage5-\(Int(helpers.screenHeight))h"))

            currentFrame = CGRectMake(0, helpers.screenHeightNoStatus/2-self.view.frame.height/2, helpers.screenWidth, self.view.frame.height)

            scrollView = UIScrollView(frame: CGRectMake(0, helpers.screenHeight-helpers.screenHeightNoStatus, helpers.screenWidth, helpers.screenHeightNoStatus))
            scrollView.delegate = self
            scrollView.pagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false

            pageControl = UIPageControl(frame: CGRectMake(0, helpers.screenHeightNoStatus, helpers.screenWidth, helpers.statusBarHeight))
			pageControl.frame.origin = CGPointMake(self.view.frame.width/2-pageControl.frame.width/2, pageControl.frame.origin.y-10)
			pageControl.numberOfPages = 5
            pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)

            tutorialViews = [background1, background2, background3, background4, background5]

            for index in 0..<tutorialViews.count {
                currentFrame.origin.x = scrollView.frame.width*CGFloat(index)

                let currentView = tutorialViews[index]
                currentView.frame = currentFrame
                scrollView.addSubview(currentView)

                if index == tutorialViews.count-1 {
                    let loginSocialImageView = UIImageView(image: UIImage(named: "LoginSocialButtons-\(Int(helpers.screenHeight))h"))
                    loginSocialImageView.frame.origin = CGPointMake(currentFrame.origin.x + (currentFrame.width/2 - loginSocialImageView.frame.width/2), currentFrame.height/2 - loginSocialImageView.frame.height/2)
                    scrollView.addSubview(loginSocialImageView)

                    loginSocialButtons = UIButton(frame: loginSocialImageView.frame)
					loginSocialButtons.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("socialLogin:")))
					scrollView.addSubview(loginSocialButtons)

                    let loginNotNowImage = UIImage(named: "LoginNotNowButton-\(Int(helpers.screenHeight))h")
                    let loginNotNowImageView = UIImageView(image: loginNotNowImage)
                    loginAnonButton = UIButton(frame: loginNotNowImageView.frame)
                    loginAnonButton.frame.origin = CGPointMake(currentFrame.origin.x + (currentFrame.width/2-loginNotNowImageView.frame.width/2), currentFrame.height-currentFrame.height/4-loginNotNowImageView.frame.height/2)
                    loginAnonButton.setImage(loginNotNowImage, forState: UIControlState.Normal)
                    loginAnonButton.addTarget(self, action: Selector("makeRegistration:"), forControlEvents: UIControlEvents.TouchUpInside)
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
	func socialLogin(gestureRecognizer: UITapGestureRecognizer) {
		if gestureRecognizer.state == UIGestureRecognizerState.Ended {
			if helpers.isRightShape(gestureRecognizer.locationInView(loginSocialButtons), frame: loginSocialButtons.frame) {
				helpers.setFacebookUser({ (response) -> () in
					response ? self.makeRegistration(0) : print("facebook error")
				})
			} else {
				helpers.setTwitterUser({ (response) -> () in
					response ? self.makeRegistration(0) : print("twitter error")
				})
			}
		}
	}

	func makeRegistration(sender: AnyObject) {
		helpers.communicationHandler.registrationRequest() { (response) -> () in
			if response {
				dispatch_async(dispatch_get_main_queue()) {
					self.performSegueWithIdentifier("presentHomeTabBarController", sender: self)
				}
			}
		}
    }
}
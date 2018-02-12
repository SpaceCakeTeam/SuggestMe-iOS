class QuestionsViewController: UIViewController, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate {

	var helpers = Helpers.shared
	var navigationBarHeight: CGFloat!
	var tabBarHeight: CGFloat!

    var loginButton: UIBarButtonItem!
    var suggestsTableView: UITableView!

	var visible = false

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
        self.tabBarController?.tabBar.backgroundColor = UIColor.whiteColor()
        self.tabBarController?.delegate = self

        loginButton = UIBarButtonItem(title: "Log In".localized, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login:"))

        let backgroundView = UIImageView(image: UIImage(named: "QuestionsBackground-\(Int(helpers.screenHeight))h"))
        self.view.addSubview(backgroundView)

        suggestsTableView = UITableView(frame: backgroundView.frame)
        suggestsTableView.delegate = self
        suggestsTableView.dataSource = self
        suggestsTableView.backgroundColor = UIColor.clearColor()
        suggestsTableView.separatorColor = UIColor.clearColor()
        suggestsTableView.rowHeight = 60
        suggestsTableView.registerClass(QuestionCell().classForCoder, forCellReuseIdentifier: "questionCellId")
        self.view.addSubview(suggestsTableView)

        self.tabBarController!.selectedIndex = 2
        self.tabBarController!.selectedIndex = 0
        self.tabBarController!.selectedIndex = 1

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationIsActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationIsBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
	}

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		helpers.user.anon == true ? self.navigationItem.setRightBarButtonItem(loginButton, animated: false) : self.navigationItem.setRightBarButtonItem(nil, animated: false)
		suggestsTableView.reloadData()
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		visible = true
		getSuggests()
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0
	}

	func applicationIsActive(notification: NSNotification) {
		visible = true
		getSuggests()
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0
	}

	func applicationIsBackground(notification: NSNotification) {
		visible = false
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		visible = false
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
			cell.category.frame.origin.x = 10
			cell.category.image = UIImage(named: "QuestionGoodsIcon")
        } else if question.questiondata.catid == 2 {
			cell.category.frame.origin.x = 7
            cell.category.image = UIImage(named: "QuestionSocialIcon")
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
						cell.setSuggestTitle(subcategory.name.localized)
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
        let selectedNavigationController = viewController as! UINavigationController
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
				if self.visible {
					dispatch_async(dispatch_get_main_queue()) {
						self.suggestsTableView.reloadData()
					}
				}
            }
        }
    }
}

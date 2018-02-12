class AboutViewController: UIViewController {

	var helpers = Helpers.shared
	var navigationBarHeight: CGFloat!
	var tabBarHeight: CGFloat!

    var loginButton: UIBarButtonItem!

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

        let backgroundView = UIImageView(image: UIImage(named: "AboutBackground-\(Int(helpers.screenHeight))h"))
        self.view.addSubview(backgroundView)

		let description = ALabel(frame: CGRectMake(0, helpers.screenHeight-tabBarHeight-navigationBarHeight-240, helpers.screenWidth, 190))
        if helpers.screenHeight == 480 {
            description.frame.origin.y += 30
        }
        description.font = UIFont(name: "Freestyle Script", size: 23)
        description.text = "SuggestMe è come un amico sincero, disponibile e sempre pronto ad aiutarti dandoti consigli in ogni  ambito della tua vita. Ti daremo consigli su tutto ciò che vorrai, senza secondi fini e nel massimo della privacy, troppo spesso violata quando ci si rivolge agli amici sbagliati."
        description.numberOfLines = 6
        description.textColor = UIColor.whiteColor()
        self.view.addSubview(description)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		helpers.user.anon == true ? self.navigationItem.setRightBarButtonItem(loginButton, animated: false) : self.navigationItem.setRightBarButtonItem(nil, animated: false)
    }

    //MARK: UIButton Actions
    func login(sender: AnyObject) {
        self.performSegueWithIdentifier("presentLoginViewController", sender: self)
    }
}

class ALabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    }
}

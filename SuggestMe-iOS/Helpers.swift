class Helpers {

	let screenHeight = UIScreen.mainScreen().bounds.size.height
	let screenWidth = UIScreen.mainScreen().bounds.size.width
	let screenHeightNoStatus = UIScreen.mainScreen().bounds.size.height-UIApplication.sharedApplication().statusBarFrame.height
	let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height

	var currentView: UIView!
	var currentViewFrame: CGRect!
	var indicatorView: UIView!

	var communicationHandler = CommunicationHandler()

	var user: User!
	var categories: [Category]!
    var questions = [Question]()
    var currentQuestion: Question?

	var pushToQuestionsView = false

    let kTwitterConsumer = ""
    let kTwitterConsumerSecret = ""

	let alertText = [
		 0:["title":"SuggestMe","message":"Errore di rete","cancel":"Chiudi"],
		-1:["title":"SuggestMe","message":"Errore sul server","cancel":"Chiudi"],
		-2:["title":"SuggestMe","message":"Errore sul server","cancel":"Chiudi"],
		-3:["title":"SuggestMe","message":"Errore sul server","cancel":"Chiudi"],
		 1:["title":"SuggestMe","message":"Completa tutti i campi","cancel":"Chiudi"],
		 2:["title":"SuggestMe","message":"Errore durante la login con Facebook","cancel":"Chiudi"],
		 3:["title":"SuggestMe","message":"Errore durante la login con Twitter","cancel":"Chiudi"]]

    //MARK: Shared instance
    class var shared: Helpers {
        struct Static {
            static var instance: Helpers?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) { Static.instance = Helpers() }
        return Static.instance!
    }

    //MARK: Check internet connection
    func connected() -> Bool {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://google.com/")!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var responseCode = -1

        let group = dispatch_group_create()
        dispatch_group_enter(group)
        session.dataTaskWithRequest(request, completionHandler: {(_, response, _) in
            if let httpResponse = response as? NSHTTPURLResponse {
                responseCode = httpResponse.statusCode
            }
            dispatch_group_leave(group)
        }).resume()
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        return (responseCode == 200)
    }

	//MARK: Spinner
    func setSpinner() {
		dispatch_async(dispatch_get_main_queue()) {
			if self.indicatorView==nil || !self.currentView.isDescendantOfView(self.indicatorView) {
				self.indicatorView = UIView(frame: CGRectMake(self.currentViewFrame.origin.x, self.currentViewFrame.origin.y, self.currentViewFrame.width,self.currentViewFrame.height))
				self.indicatorView.backgroundColor = UIColor.clearColor()

				let indicatorSubView = UIView(frame: CGRect(x: self.indicatorView.frame.width/2-self.indicatorView.frame.width/8, y: self.indicatorView.frame.height/2-self.indicatorView.frame.width/8, width: self.indicatorView.frame.width/4, height: self.indicatorView.frame.width/4))
				indicatorSubView.layer.cornerRadius = 15
				indicatorSubView.backgroundColor = UIColor.whiteColor()

				let indicator = UIActivityIndicatorView(frame: CGRect(x: indicatorSubView.frame.width/2-indicatorSubView.frame.width/4, y: indicatorSubView.frame.height/2-indicatorSubView.frame.height/4, width: indicatorSubView.frame.width/2, height: indicatorSubView.frame.height/2))
				indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
				indicator.color = UIColor.blackColor()
				indicator.startAnimating()

				indicatorSubView.addSubview(indicator)
				self.indicatorView.addSubview(indicatorSubView)
				self.currentView.addSubview(self.indicatorView)
			}
		}
    }

	func removeSpinner() {
		dispatch_async(dispatch_get_main_queue()) {
			if self.indicatorView != nil {
				self.indicatorView!.removeFromSuperview()
				self.indicatorView = nil
			}
		}
	}

	//MARK: Alert
	func showAlert(id: Int) {
        if alertText[id] != nil {
            var alertTextDict: [String:String] = alertText[id]!
            let title: String? = alertTextDict["title"]
            let message: String? = alertTextDict["message"]
            let cancel: String? = alertTextDict["cancel"]
            dispatch_async(dispatch_get_main_queue()) {
                UIAlertView(title: title?.localized, message: message?.localized, delegate: nil, cancelButtonTitle: cancel?.localized).show()
            }
        }
	}

	//MARK: Setting font
	func getAppFont() -> String! {
		return "Helvetica Neue"
	}

    func printFonts() {
        for var i=0; i<UIFont.familyNames().count; ++i {
            print("\(UIFont.familyNames()[i])");
            for var j=0; j<UIFont.fontNamesForFamilyName(UIFont.familyNames()[i]).count; ++j {
                print("\(UIFont.fontNamesForFamilyName(UIFont.familyNames()[i])[j])");
            }
        }
    }

    //MARK: Setting data user
    func setDataUser() -> Bool {
        if isStored("user") {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(dataStored("user") as! NSData) as! User
			categories = NSKeyedUnarchiver.unarchiveObjectWithData(dataStored("categories") as!  NSData) as! [Category]
			if isStored("questions") {
				questions = NSKeyedUnarchiver.unarchiveObjectWithData(dataStored("questions") as! NSData) as! [Question]
			}
			return true
        }
        else {
            user = User(id: -1, anon: true, userdata: UserData(name: "", surname: "", birthdate: 0, gender: Gender.u, email: ""))
            return false
        }
    }

	//MARK: Check question Text!
	func checkQuestionText(questionText: String!) -> Bool {
		//TODO
		return true
	}

	//MARK: Social methods
	func setFacebookUser(callback: (Bool) -> ()) {
		FBSDKLoginManager().logInWithReadPermissions(["email","user_birthday"]) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
			if (error == nil && FBSDKAccessToken.currentAccessToken() != nil) {
				self.setSpinner()
				if self.connected() {
					FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name,first_name,email,last_name,birthday,gender"]).startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
						self.removeSpinner()
						if error == nil {
							let userdata = self.user.userdata
							var resultData = result as! [String: String]
							userdata.name = resultData["first_name"]
							userdata.surname = resultData["last_name"]
							userdata.birthdate = self.resolveDate(resultData["birthday"]!)
							userdata.gender = self.resolveGender(resultData["gender"]!)
							userdata.email = resultData["email"]
							callback(true)
						} else {
							self.showAlert(2)
							callback(false)
						}
					})
				} else {
					self.removeSpinner()
					self.showAlert(0)
					callback(false)
				}
			} else {
				self.showAlert(2)
				callback(false)
			}
		}
	}

	func setTwitterUser(callback: (Bool) -> ()) {
		let accountsStore = ACAccountStore()
		let accountType = accountsStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
		accountsStore.requestAccessToAccountsWithType(accountType, options: nil, completion: { (granted: Bool, error: NSError!) -> Void in
			if granted && error == nil {
				let accounts = accountsStore.accountsWithAccountType(accountType)
				if accounts.count > 0 {
					let account = accountsStore.accountsWithAccountType(accountType).first as! ACAccount
					let userdata = self.user.userdata
					userdata.name = account.username
					userdata.surname = "(Twitter)"
					return callback(true)
				} else {
					self.showAlert(3)
					return callback(false)
				}
			} else {
				self.showAlert(3)
				return callback(false)
			}
		})
	}

	//MARK: Push!
	func registerPush() {
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert,.Badge,.Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Sound,.Alert,.Badge])
        }
    }

	func isPushRegisteredAtLeastOneTime() -> Bool {
		return isStored("remoteNotificationEnabled")
	}

	func storePushDataEnabled(deviceToken: String, enabled: Bool) {
		storeData("remoteNotificationPushToken", data: deviceToken)
		storeData("remoteNotificationEnabled", data: enabled)
	}

	func pushInSystem() -> Bool {
        if #available(iOS 8.0, *) {
            return UIApplication.isRegisteredForRemoteNotifications(UIApplication.sharedApplication())()
        } else {
            if UIApplication.enabledRemoteNotificationTypes(UIApplication.sharedApplication())() == UIRemoteNotificationType.None {
                return false
            } else {
                return true
            }
        }
	}

	func pushEnabled() -> Bool {
		return pushInSystem()
	}

	func pushChanged() -> Bool {
		if dataStored("remoteNotificationEnabled") as! Bool != pushInSystem() {
			return true
		} else {
			return false
		}
	}

	func updatePushRequest(deviceToken: String) {
		communicationHandler.pushTokenRequest(["device":"ios","token":deviceToken], callback: { (response: Bool) -> () in
			if response {
				self.storePushDataEnabled(deviceToken, enabled: deviceToken == "" ? false : true)
			}
		})
	}

	//MARK: Others!
	func isStored(key: String) -> Bool {
		return NSUserDefaults.standardUserDefaults().objectForKey(key) != nil
	}

	func storeData(key: String, data: AnyObject) {
		NSUserDefaults.standardUserDefaults().setObject(data, forKey: key)
	}

	func dataStored(key: String) -> AnyObject {
		return NSUserDefaults.standardUserDefaults().objectForKey(key)!
	}

	func isRightShape(point: CGPoint, frame: CGRect) -> Bool {
		let frame1 = CGRect(x: frame.width/6, y: 0, width: frame.width/6*5, height: frame.height/6)
		let frame2 = CGRect(x: frame.width/6*2, y: 0, width: frame.width/6*4, height: frame.height/6*2)
		let frame3 = CGRect(x: frame.width/6*3, y: 0, width: frame.width/6*3, height: frame.height/6*3)
		let frame4 = CGRect(x: frame.width/6*4, y: 0, width: frame.width/6*2, height: frame.height/6*4)
		let frame5 = CGRect(x: frame.width/6*5, y: 0, width: frame.width/6, height: frame.height/6*5)
		if CGRectContainsPoint(frame1, point) || CGRectContainsPoint(frame2, point) || CGRectContainsPoint(frame3, point) || CGRectContainsPoint(frame4, point) || CGRectContainsPoint(frame5, point) {
			return true
		} else {
			return false
		}
	}

	func resolveGender(gender: String) -> Gender {
		switch gender {
		case "male": return Gender.m
		case "female": return Gender.f
		default: return Gender.u
		}
	}

	func resolveDate(date: String) -> Int {
		return Int(date.toDateTime().timeIntervalSince1970)
	}
}

extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
	}

	func toDateTime() -> NSDate {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MM/DD/YYYY"
		let dateFromString: NSDate = dateFormatter.dateFromString(self)!
		return dateFromString
	}
}
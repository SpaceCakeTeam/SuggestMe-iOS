class CommunicationHandler: NSObject, NSURLSessionTaskDelegate {

    #if Staging
    let baseUrl = "http://server.federicomaggi.me/"
	let pushUri = "onlypush"
    let registrationUri = "registration"
    let getCategoriesUri = "getcategories"
    let askSuggestionUri = "asksuggestion"
    let getSuggestsUri = "getsuggests"
    let secret = ""
    #endif

    #if Production
	let baseUrl = "https://services.suggestme.us/"
	let pushUri = "onlypush"
    let registrationUri = "registration"
    let getCategoriesUri = "getcategories"
    let askSuggestionUri = "asksuggestion"
    let getSuggestsUri = "getsuggests"
    let secret = ""
    #endif

    //MARK: Service request
    func serviceRequest(requestUri: String!, requestData: AnyObject, callback: (AnyObject) -> ()) {
        if Helpers.shared.connected() {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            let user = Helpers.shared.user
            var requestDataWithIdAndSecret: [String: AnyObject]
            if requestUri == registrationUri {
				if user.userdata.name == "" { user.anon = true } else { user.anon = false }
                requestDataWithIdAndSecret = ["userid": user.id, "anonflag": user.anon, "userdata": user.userdata.convertToDict(), "secret": secret]
            } else {
                requestDataWithIdAndSecret = ["userid": user.id, "userdata": requestData, "secret": secret]
            }

            var requestDataSerialized: NSData?
            do {
                requestDataSerialized = try NSJSONSerialization.dataWithJSONObject(requestDataWithIdAndSecret, options: .PrettyPrinted)
            } catch _ as NSError {
                callback(["status": "ko","errno":0])
            }
            let session = NSURLSession(configuration: .defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.currentQueue())

            let request = NSMutableURLRequest(URL: NSURL(string: baseUrl+requestUri)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = requestDataSerialized
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 6.0

            var task = NSURLSessionDataTask()
			task = session.dataTaskWithRequest(request) { (responseData, response, error) in

				UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                if let responseHttp = response as? NSHTTPURLResponse {
                    if responseHttp.statusCode == 200 {
                        do {
                            let responseDataParsed = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableLeaves)
                            callback(responseDataParsed)
                        } catch _ as NSError {
                            callback(["status": "ko","errno":0])
                        }
					} else {
						callback(["status": "ko","errno":0])
					}
				} else {
					callback(["status": "ko","errno":0])
				}
			}
            task.resume()
        } else {
            callback(["status": "ko","errno":0])
        }
    }

    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }

	//MARK: Push token request
	func pushTokenRequest(pushData: [String: AnyObject]!, callback: (Bool) -> ()) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			self.serviceRequest(self.pushUri, requestData: pushData) { (response) -> () in

				print("Push token request response: \(response)")

				if response["status"] as! String == "ok" {
					callback(true)
				} else if response["status"] as! String == "ko" {
					Helpers.shared.showAlert(response["errno"] as! Int)
					callback(false)
				}
			}
		}
	}

    //MARK: Registration request
    func registrationRequest(callback: (Bool) -> ()) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			Helpers.shared.setSpinner()
			self.serviceRequest(self.registrationUri, requestData: [String: AnyObject]()) { (response) -> () in

				Helpers.shared.removeSpinner()
				print("Registration request response: \(response)")

				if response["status"] as! String == "ok" {
					var responseData = response["data"] as! [String: Int]
					self.getCategoriesRequest(){ (response2) -> () in
						if response2 {
							Helpers.shared.user.id = responseData["userid"]
							Helpers.shared.storeData("user", data: NSKeyedArchiver.archivedDataWithRootObject(Helpers.shared.user))
							Helpers.shared.registerPush()
							callback(response2)
						}
						callback(response2)
					}
				} else if response["status"] as! String == "ko" {
					Helpers.shared.user.anon = true
					Helpers.shared.showAlert(response["errno"] as! Int)
					callback(false)
				}
			}
		}
    }

    //MARK: Categories request
    func getCategoriesRequest(callback: (Bool) -> ()) {
		serviceRequest(getCategoriesUri, requestData: [String: AnyObject]()) { (response) -> () in

			print("Categories request response: \(response)")

			if response["status"] as! String == "ok" {
                var responseData = response["data"] as! [String: AnyObject]
                let responseCategories = responseData["categories"] as! [AnyObject]
                var categories = [Category]()
                for responseCategory in responseCategories {
                    var subcategories = [SubCategory]()
                    for responseSubCategory in responseCategory["subcategories"] as! [AnyObject] {
                        subcategories.append(SubCategory(id: responseSubCategory["subcategoryid"] as! Int, name: responseSubCategory["subcategoryname"] as! String))
                    }
                    categories.append(Category(id: responseCategory["categoryid"] as! Int, name: responseCategory["category"] as! String, subcategories: subcategories as [SubCategory]))
                }
				Helpers.shared.storeData("categories", data: NSKeyedArchiver.archivedDataWithRootObject(categories))
				Helpers.shared.categories = categories
				callback(true)
            } else if response["status"] as! String == "ko" {
				Helpers.shared.showAlert(response["errno"] as! Int)
                callback(false)
            }
        }
    }

    //MARK: Ask suggestion request
    func askSuggestionRequest(questionData: QuestionData! , callback: (Bool) -> ()) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			Helpers.shared.setSpinner()
			self.serviceRequest(self.askSuggestionUri, requestData: questionData.convertToDict()) { (response) -> () in

				print("Ask suggestion request response: \(response)")
				Helpers.shared.removeSpinner()

				if response["status"] as! String == "ok" {
					var responseData = response["data"] as! [String: AnyObject]
					let question = Question(id: responseData["questionid"] as! Int, questiondata: questionData, date: responseData["timestamp"] as! Int, suggest: nil)
					Helpers.shared.questions.append(question)
					Helpers.shared.storeData("questions", data: NSKeyedArchiver.archivedDataWithRootObject(Helpers.shared.questions))
					callback(true)
				} else if response["status"] as! String == "ko" {
					Helpers.shared.showAlert(response["errno"] as! Int)
					callback(false)
				}
			}
		}
    }

    //MARK: Get suggests request
    func getSuggestsRequest(questionsId: [Int]!, callback: (Bool) -> ())  {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			self.serviceRequest(self.getSuggestsUri, requestData: questionsId) { (response) -> () in

				print("Get suggests request response: \(response)")

				if response["status"] as! String == "ok" {
					var responseData = response["data"] as! [String: AnyObject]
					let responseSuggests = responseData["suggests"] as! [AnyObject]
					for question in Helpers.shared.questions {
						for responseSuggest in responseSuggests {
							let suggest = Suggest(id: responseSuggest["suggestid"] as! Int, text: responseSuggest["text"] as! String)
							if question.id == responseSuggest["questionid"] as! Int {
								question.suggest = suggest
								break
							}
						}
					}
                    Helpers.shared.questions.sortInPlace({$0.date>$1.date})
                    Helpers.shared.storeData("questions", data: NSKeyedArchiver.archivedDataWithRootObject(Helpers.shared.questions))
					callback(true)
				} else if response["status"] as! String == "ko" {
					callback(false)
				}
			}
		}
    }
}
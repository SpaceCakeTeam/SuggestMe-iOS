//
//  Utility.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation
import UIKit
import Accounts
import Social

class Utility {
    
    
    //MARK: Shared instance
    
    class var sharedInstance: Utility {
        struct Static {
            static var instance: Utility?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Utility()
        }
        return Static.instance!
    }
    
    var communicationHandler = CommunicationHandler()
    var activityIndicatorView: UIView!
    var user: User!
    var accountStore = ACAccountStore()
    var categories: [Category]!
    
    
    //MARK: Check internet connection
    
    func isConnectedToNetwork() -> Bool {
        var status = false
        let request = NSMutableURLRequest(URL: NSURL(string: "http://google.com/")!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
    }
    
    
    //MARK: Social methods
    
    func requestAccessToAccount(accountType: ACAccountType, permissionDict: [String: AnyObject], url: String, serviceType: String, serviceParams: [String: AnyObject]) {
        accountStore.requestAccessToAccountsWithType(accountType, options: permissionDict) { (granted: Bool, error: NSError!) -> Void in
            if granted {
                var account = self.accountStore.accountsWithAccountType(accountType).last as! ACAccount
                var accessToken = account.credential.oauthToken
                var request = SLRequest(forServiceType: serviceType, requestMethod: SLRequestMethod.GET, URL: NSURL(string: url), parameters: serviceParams)
                request.account = account
                self.serviceAccessToAccount(request, account: account)
            }
        }
    }
    
    func serviceAccessToAccount(request: SLRequest, account: ACAccount) {
        request.performRequestWithHandler({ (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            if error != nil {
                var dataDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! [String: AnyObject]
                if dataDict["error"] != nil {
                    self.accountStore.renewCredentialsForAccount(account, completion: { (renewResult: ACAccountCredentialRenewResult, error: NSError!) -> Void in
                        if error != nil {
                            switch(renewResult) {
                            case ACAccountCredentialRenewResult.Renewed:
                                self.serviceAccessToAccount(request, account: account)
                                break
                            case ACAccountCredentialRenewResult.Rejected:
                                break
                            case ACAccountCredentialRenewResult.Failed:
                                break
                            default:
                                break
                            }
                        }
                    })
                }
            }
        })
    }
    
    
    //MARK: Activity indicator!
    
    func setActivityIndicator(frame: CGRect, text: String) -> UIView {
        activityIndicatorView = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height))
        
        var textView = UIView(frame: CGRect(x: frame.width/2-125, y: frame.height/2-25, width: 250, height: 50))
        textView.layer.cornerRadius = 15
        textView.backgroundColor = UIColor.whiteColor()
       
        var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 0, width: 50, height: 50))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.startAnimating()
        textView.addSubview(activityIndicator)

        var textLabel = UILabel(frame: CGRect(x: 70, y: 0, width: textView.frame.width-70, height: textView.frame.height))
        textLabel.text = text
        textLabel.textColor = UIColor.blackColor()
        textLabel.textAlignment = NSTextAlignment.Left
        textView.addSubview(textLabel)
        
        activityIndicatorView.addSubview(textView)
        return activityIndicatorView
    }
    
    
    //MARK: Setting user
    
    func setUser() -> Bool {
        var userStored: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("user")
        if userStored != nil {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("user") as! NSData) as! User
            setCategories()
            return true
        }
        else {
            user = User(id: -1, anon: true, userdata: UserData(name: "", surname: "", birthdate: 0, gender: Gender.u, email: ""))
            return false
        }
    }
    
    
    //MARK: Get Facebook user
    func getFacebookAccount() {
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        var permissionsDict = ["451805654875339": ACFacebookAppIdKey, "email": ACFacebookPermissionsKey]
        requestAccessToAccount(accountType, permissionDict: permissionsDict, url: "https://graph.facebook.com/me", serviceType: SLServiceTypeFacebook, serviceParams: [String: AnyObject]())
    }
    
    
    //MARK: Get Twitter user
    func getTwitterAccount() {
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        requestAccessToAccount(accountType, permissionDict: [String: AnyObject](), url: "https://api.twitter.com/1.1/account/verify_credentials.json", serviceType: SLServiceTypeTwitter, serviceParams: [String: AnyObject]())
    }
    
    
    //MARK: Setting categories
    
    func setCategories() {
        Utility.sharedInstance.communicationHandler.getCategoriesRequest() { (response) -> () in
            println("Categories Request response: \(response)")
        }
    }
    
    
    /////////EXAMPLE
    func askSuggestionRequestTest() {
        var questiondata = QuestionData(catid: 1, subcatid: 1, text: "ciaone cosa vuol dire?", anon: true)
        
        Utility.sharedInstance.communicationHandler.askSuggestionRequest(questiondata) { (response) -> () in
            println("Ask Suggestion Request response: \(response)")
        }
    }
    
    func getSuggestsRequestTest() {
        Utility.sharedInstance.communicationHandler.getSuggestsRequest([84]) { (response) -> () in
            println("Get Suggests Request response: \(response)")
        }
    }
}
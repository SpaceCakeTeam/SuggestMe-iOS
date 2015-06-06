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
    
    var communicationHandler = CommunicationHandler()
    var activityIndicatorView: UIView!
    var user: User!
    var accountStore = ACAccountStore()
    var categories: [Category]!
    var questions = [Question]()
    var currentQuestion: Question?
    
    
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
    
    func getFacebookAccount() {
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        var permissionsDict = ["451805654875339": ACFacebookAppIdKey, "email": ACFacebookPermissionsKey]
        requestAccessToAccount(accountType, permissionDict: permissionsDict, url: "https://graph.facebook.com/me", serviceType: SLServiceTypeFacebook, serviceParams: [String: AnyObject]())
    }
    
    func getTwitterAccount() {
        var accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        requestAccessToAccount(accountType, permissionDict: [String: AnyObject](), url: "https://api.twitter.com/1.1/account/verify_credentials.json", serviceType: SLServiceTypeTwitter, serviceParams: [String: AnyObject]())
    }
    
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
    
    func setActivityIndicator(frame: CGRect) -> UIView {
        activityIndicatorView = UIView(frame: CGRect(x: frame.width/2-frame.width/8, y: frame.height/2-frame.width/8, width: frame.width/4, height: frame.width/4))
        activityIndicatorView.layer.cornerRadius = 15
        activityIndicatorView.backgroundColor = UIColor.whiteColor()
       
        var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: activityIndicatorView.frame.width/2-activityIndicatorView.frame.width/4, y: activityIndicatorView.frame.height/2-activityIndicatorView.frame.height/4, width: activityIndicatorView.frame.width/2, height: activityIndicatorView.frame.height/2))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.startAnimating()
        activityIndicatorView.addSubview(activityIndicator)

        return activityIndicatorView
    }
    
    
    //MARK: Setting user
    
    func setUser() -> Bool {
        var userStored: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("user")
        if userStored != nil {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("user") as! NSData) as! User
            questions = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("questions") as! NSData) as! [Question]
            setCategories()
            getSuggests()
            return true
        }
        else {
            user = User(id: -1, anon: true, userdata: UserData(name: "", surname: "", birthdate: 0, gender: Gender.u, email: ""))
            return false
        }
    }
    
    
    //MARK: Setting categories
    
    func setCategories() {
        Utility.sharedInstance.communicationHandler.getCategoriesRequest() { (response) -> () in
            println("Categories Request response: \(response)")
        }
    }
    
    
    //MARK: Getting suggests
    
    func getSuggests() {
        var suggestsRequest = [Int]()
        for question in questions {
            if question.suggest == nil {
                suggestsRequest.append(question.id)
            }
        }
        Utility.sharedInstance.communicationHandler.getSuggestsRequest(suggestsRequest) { (response) -> () in
            println("Get Suggests Request response: \(response)")
        }
    }
}
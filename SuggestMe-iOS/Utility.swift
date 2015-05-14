//
//  Utility.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Utility {
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
    
    func registrationRequestTest() {
        //NSUserDefaults.standardUserDefaults().setObject(User(id: nil), forKey: "userInfo")
        //var userInfo =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as! User
        
        var userSocial = UserSocial(id: -1, tokenId: "blabla", email: "dio@dio.dio", name: "Dio", surname: "Dio", birthDate: 0, gender: Gender.u)
        var userSocialEncoded = NSKeyedArchiver.archivedDataWithRootObject(userSocial)
        NSUserDefaults.standardUserDefaults().setObject(userSocialEncoded, forKey: "userinfo")
        //var userInfo =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as! UserSocial

        Utility.sharedInstance.communicationHandler.registrationRequest(false, userNotRegistered: userSocial.castToDictionary()) { (response) -> () in
            println("Registration Request response: \(response)")
        }
    }
    
    func getCategoriesRequestTest() {
        Utility.sharedInstance.communicationHandler.getCategoriesRequest() { (response) -> () in
            println("Categories Request response: \(response)")
        }
    }
    
    func askSuggestionRequestTest() {
        var question = Question(id: -1, anonflag: true, text: "ciao?", category: 1, subcategory: 1, date: -1)
        Utility.sharedInstance.communicationHandler.askSuggestionRequest(question.convertToDictionary()) { (response) -> () in
            println("Ask Suggestion Request response: \(response)")
        }
    }
    
    func getSuggestsRequestTest() {
        Utility.sharedInstance.communicationHandler.getSuggestsRequest([1,2,3]) { (response) -> () in
            println("Get Suggests Request response: \(response)")
        }
    }
}
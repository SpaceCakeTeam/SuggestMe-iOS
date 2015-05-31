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
    
    var user: User!
    
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
    
    func setUser() -> Bool {
        var userStored: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("user")
        if userStored != nil {
            user = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("user") as! NSData) as! User
            return true
        }
        else {
            user = User(id: -1, anon: true, userdata: UserData(name: "", surname: "", birthdate: 0, gender: Gender.u, email: ""))
            return false
        }
    }
    
    
    
    
    
    
    func getCategoriesRequestTest() {
        Utility.sharedInstance.communicationHandler.getCategoriesRequest() { (response) -> () in
            println("Categories Request response: \(response)")
        }
    }
    
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
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
    
    func setUser() {
        var user = User(id: -1, anon: true, userdata: nil)
        var userEncoded = NSKeyedArchiver.archivedDataWithRootObject(user)
        NSUserDefaults.standardUserDefaults().setObject(userEncoded, forKey: "user")
    }
    
    func registrationRequestTest() {
        var userdata = UserData(name: "Zazu", surname: "Culo", birthdate: 16000, gender: Gender.u, email: "zazu.culo@gmail.com")        

        Utility.sharedInstance.communicationHandler.registrationRequest(userdata) { (response) -> () in
            println("Registration Request response: \(response)")
        }
    }
    
    func getCategoriesRequestTest() {
        Utility.sharedInstance.communicationHandler.getCategoriesRequest() { (response) -> () in
            println("Categories Request response: \(response)")
        }
    }
    
    func askSuggestionRequestTest() {
        var questiondata = QuestionData(catid: 1, subcatid: 1, text: "ciaone cosa vuol dire?", anon: false)
        
        Utility.sharedInstance.communicationHandler.askSuggestionRequest(questiondata) { (response) -> () in
            println("Ask Suggestion Request response: \(response)")
        }
    }
    
    func getSuggestsRequestTest() {
        Utility.sharedInstance.communicationHandler.getSuggestsRequest([1]) { (response) -> () in
            println("Get Suggests Request response: \(response)")
        }
    }
}
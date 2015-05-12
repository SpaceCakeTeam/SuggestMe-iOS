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
        var Status: Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        return Status
    }
}

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
    
    func hasConnectivity() -> Bool {
        return true
    }
}

//
//  User.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var id: Int = -1

    init(id: Int) {
        self.id = id
    }
    
    func castToDictionary() -> [String: AnyObject] {
        return ["userid": self.id]
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("id") 
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
    }
}

//
//  User.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var id: Int!
    var anon: Bool!
    var userdata: UserData?

    init(id: Int!, anon: Bool!, userdata: UserData?) {
        self.id = id
        self.anon = anon
        self.userdata = userdata
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("id")
        decoder.decodeObjectForKey("anon")
        decoder.decodeObjectForKey("userdata")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.anon, forKey: "anon")
        encoder.encodeObject(self.userdata, forKey: "userdata")
    }
}

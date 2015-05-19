//
//  UserData.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class UserData: NSObject, NSCoding {
    var name: String!
    var surname: String!
    var birthdate: Int!
    var gender: Gender!
    var email: String!
    
    init(name: String!, surname: String!, birthdate: Int!, gender: Gender!, email: String!) {
        self.name = name
        self.surname = surname
        self.birthdate = birthdate
        self.gender = gender
        self.email = email
    }
    
    func convertToDict() -> [String: AnyObject!] {
        return ["name": self.name, "surname": self.surname, "birth_date": self.birthdate, "gender": self.gender.rawValue, "email": self.email]
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObjectForKey("name") as! String
        self.surname = decoder.decodeObjectForKey("surname") as! String
        self.birthdate = decoder.decodeObjectForKey("birthdate") as! Int
        self.gender = decoder.decodeObjectForKey("gender") as! Gender
        self.email = decoder.decodeObjectForKey("email") as! String
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.surname, forKey: "surname")
        encoder.encodeObject(self.birthdate, forKey: "birthdate")
        encoder.encodeObject(self.gender.rawValue, forKey: "gender")
        encoder.encodeObject(self.email, forKey: "email")
    }
}

enum Gender: String {
    case m = "m"
    case f = "f"
    case u = "u"
}
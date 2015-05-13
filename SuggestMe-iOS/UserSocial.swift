//
//  UserSocial.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class UserSocial: User {
    var tokenId: String = ""  //verificare se dopo un logout quello nuovo generato è diverso, in caso negativo scrivere let
    var email: String = ""
    var name: String = ""
    var surname: String = ""
    var birthDate: Int = -1
    var gender = Gender.u
    
    init(id: Int, tokenId: String, email: String, name: String, surname: String, birthDate: Int, gender: Gender) {
        self.tokenId = tokenId
        self.email = email
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
        self.gender = gender
        super.init(id: id)
    }
    
    override func castToDictionary() -> [String: AnyObject] {
        return ["userid": self.id, "tokenId": self.tokenId, "email": self.email, "name": self.name, "surname": self.surname, "birth_date": self.birthDate, "gender": self.gender.rawValue]
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        decoder.decodeObjectForKey("tokenId")
        decoder.decodeObjectForKey("email")
        decoder.decodeObjectForKey("name")
        decoder.decodeObjectForKey("surname")
        decoder.decodeObjectForKey("birthDate")
        decoder.decodeObjectForKey("gender") 
    }
    
    override func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.tokenId, forKey: "tokenId")
        encoder.encodeObject(self.email, forKey: "email")
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.surname, forKey: "surname")
        encoder.encodeObject(self.birthDate, forKey: "birthDate")
        encoder.encodeObject(self.gender.rawValue, forKey: "gender")
    }
}

enum Gender: String {
    case m = "Male"
    case f = "Female"
    case u = "Unknown"
}
//
//  UserSocial.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class UserSocial: User {
    var tokenId: String  //verificare se dopo un logout quello nuovo generato è diverso, in caso negativo scrivere let
    var email: String
    var name: String?
    var surname: String?
    var birthDate: Int?
    var gender: Gender?
    
    init(id: Int, tokenId: String, email: String, name: String?, surname: String?, birthDate: Int?, gender: Gender?) {
        self.tokenId = tokenId
        self.email = email
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
        self.gender = gender
        super.init(id: id)
    }
}

enum Gender: String {
    case m = "Male"
    case f = "Female"
    case u = "Unknown"
}
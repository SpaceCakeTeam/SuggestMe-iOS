//
//  Suggest.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 17/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Suggest: NSObject, NSCoding {
    var id: Int!
    var text: String!
    
    init(id: Int!, text: String!) {
        self.id = id
        self.text = text
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("id")
        decoder.decodeObjectForKey("text")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.text, forKey: "text")
    }
}
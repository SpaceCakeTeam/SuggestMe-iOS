//
//  Category.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Category: NSObject, NSCoding {
    var id: Int!
    var name: String!
    var subcategories: [SubCategory!]!
    
    init(id: Int!, name: String!, subcategories: [SubCategory!]!) {
        self.id = id
        self.name = name
        self.subcategories = subcategories
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("id")
        decoder.decodeObjectForKey("name")
        decoder.decodeObjectForKey("subcategories")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.subcategories, forKey: "subcategories")
    }
}

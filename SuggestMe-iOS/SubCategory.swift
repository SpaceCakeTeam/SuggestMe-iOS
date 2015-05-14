//
//  SubCategory.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 14/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class SubCategory: NSObject, NSCoding {
    var id = -1
    var name = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("id")
        decoder.decodeObjectForKey("name")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.name, forKey: "name")
    }
}
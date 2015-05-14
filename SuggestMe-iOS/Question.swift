//
//  Question.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Question: NSObject, NSCoding {
    var id = -1
    var anonflag = true
    var text = ""
    var category = -1
    var subcategory = -1
    var date = 0
    
    init(id: Int, anonflag: Bool, text: String, category: Int, subcategory: Int, date: Int) {
        self.id = id
        self.anonflag = anonflag
        self.text = text
        self.category = category
        self.subcategory = subcategory
        self.date = date
    }
    
    func convertToDictionary() -> [String: AnyObject] {
        return ["id": self.id, "anonfalg": self.anonflag, "text": self.text, "categoryid": self.category, "subcategoryid": self.subcategory, "date": self.date]
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("id")
        decoder.decodeObjectForKey("anonflag")
        decoder.decodeObjectForKey("text")
        decoder.decodeObjectForKey("category")
        decoder.decodeObjectForKey("subcategory")
        decoder.decodeObjectForKey("date")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.anonflag, forKey: "anonflag")
        encoder.encodeObject(self.text, forKey: "text")
        encoder.encodeObject(self.category, forKey: "category")
        encoder.encodeObject(self.subcategory, forKey: "subcategory")
        encoder.encodeObject(self.date, forKey: "date")
    }
}

struct Suggest {
    let id: Int
    let content: String
}
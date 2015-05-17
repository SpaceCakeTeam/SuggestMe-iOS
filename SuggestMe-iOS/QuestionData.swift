//
//  QuestionData.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 17/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class QuestionData: NSObject, NSCoding {
    var catid: Int!
    var subcatid: Int!
    var text: String!
    var anon: Bool!
    
    init(catid: Int!, subcatid: Int!, text: String!, anon: Bool!) {
        self.catid = catid
        self.subcatid = subcatid
        self.text = text
        self.anon = anon
    }
    
    func convertToDict() -> [String: AnyObject!] {
        return ["categoryid": self.catid, "subcategoryid": self.subcatid, "text": self.text, "anonflag": self.anon]
    }
    
    required init(coder decoder: NSCoder) {
        decoder.decodeObjectForKey("catid")
        decoder.decodeObjectForKey("subcatid")
        decoder.decodeObjectForKey("text")
        decoder.decodeObjectForKey("anon")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.catid, forKey: "catid")
        encoder.encodeObject(self.subcatid, forKey: "subcatid")
        encoder.encodeObject(self.text, forKey: "text")
        encoder.encodeObject(self.anon, forKey: "anon")
    }
}

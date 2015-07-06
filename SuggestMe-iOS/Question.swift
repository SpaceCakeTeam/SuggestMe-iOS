//
//  Question.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Question: NSObject, NSCoding {
	
	var id: Int!
    var questiondata: QuestionData!
    var date: Int!
    var suggest: Suggest?
    
    init(id: Int!, questiondata: QuestionData!, date: Int!, suggest: Suggest?) {
        self.id = id
        self.questiondata = questiondata
        self.date = date
        self.suggest = suggest
    }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as! Int
        self.questiondata = decoder.decodeObjectForKey("questiondata") as! QuestionData
        self.date = decoder.decodeObjectForKey("date") as! Int
        self.suggest = decoder.decodeObjectForKey("suggest") as? Suggest
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.questiondata, forKey: "questiondata")
        encoder.encodeObject(self.date, forKey: "date")
        encoder.encodeObject(self.suggest, forKey: "suggest")
    }
}
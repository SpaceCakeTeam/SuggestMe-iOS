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
        decoder.decodeObjectForKey("id")
        decoder.decodeObjectForKey("questiondata")
        decoder.decodeObjectForKey("date")
        decoder.decodeObjectForKey("suggest")
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.questiondata, forKey: "questiondata")
        encoder.encodeObject(self.date, forKey: "date")
        encoder.encodeObject(self.suggest, forKey: "suggest")
    }
}
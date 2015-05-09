//
//  Question.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Question {
    var id: Int?
    var anonymous: Bool
    var title: Int
    var content: String
    var category: Int
    var date: Int?
    var suggest: Suggest?
    
    init(id: Int?, anonymous: Bool, title: Int, content: String, category: Int, date: Int, suggest: Suggest?) {
        self.id = id
        self.anonymous = anonymous
        self.title = title
        self.content = content
        self.category = category
        self.date = date
        self.suggest = suggest
    }
}

struct Suggest {
    let id: Int
    let content: String
}
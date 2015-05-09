//
//  Category.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 09/05/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import Foundation

class Category {
    let id: Int
    let name: String
    let subCategories: [SubCategory]
    
    init(id: Int, name: String, subCategories: [SubCategory]) {
        self.id = id
        self.name = name
        self.subCategories = subCategories
    }
}

struct SubCategory {
    let id: Int
    let name: String
}

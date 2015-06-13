//
//  QuestionCell.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 03/06/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    var category: UIImageView!
    var textSuggest: UILabel!
    var status: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        category = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        self.addSubview(category)
        
        textSuggest = UILabel(frame: CGRect(x: 30, y: 10, width: self.frame.width - 50, height: 30))
        textSuggest.textAlignment = NSTextAlignment.Center
        self.addSubview(textSuggest)
        
        status = UIImageView(frame: CGRect(x: self.frame.width - 40, y: 10, width: 30, height: 30))
        self.addSubview(status)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

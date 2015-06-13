//
//  SubcategoryCell.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 13/06/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

import UIKit

class SubcategoryCell: UITableViewCell {
    
    var textCell: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textCell = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        textCell.textAlignment = NSTextAlignment.Center
        self.addSubview(textCell)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

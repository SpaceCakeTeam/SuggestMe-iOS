//
//  SubcategoryCell.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 13/06/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

class SubcategoryCell: UITableViewCell {
	
	var helpers = Helpers.shared

    var textCell: UILabel!
    
    //MARK: UI methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let subcategoryButtonImageView = UIImageView(image: UIImage(named: "SubcategoryButton"))
        textCell = UILabel(frame: CGRect(x: 5, y: 0, width: subcategoryButtonImageView.frame.width-10, height: subcategoryButtonImageView.frame.height))
        textCell.textAlignment = NSTextAlignment.Center
		textCell.font = UIFont(name: helpers.getAppFont(), size: 16)
        textCell.adjustsFontSizeToFitWidth = true
        textCell.minimumScaleFactor = 1
        self.addSubview(textCell)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

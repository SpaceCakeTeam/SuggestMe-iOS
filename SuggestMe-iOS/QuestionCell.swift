//
//  QuestionCell.swift
//  SuggestMe-iOS
//
//  Created by Mattia Uggè on 03/06/15.
//  Copyright (c) 2015 Mattia. All rights reserved.
//

class QuestionCell: UITableViewCell {
	
	var helpers = Helpers.shared

    var category: UIImageView!
    var textSuggest: UILabel!
    var status: UIImageView!
    
    //MARK: UI methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        category = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        self.addSubview(category)
		
		textSuggest = UILabel(frame: CGRect(x: Int(category.frame.width)+20, y: 0, width: Int(helpers.screenWidth) - 140, height: 60))
		textSuggest.textAlignment = NSTextAlignment.Left
		textSuggest.font = UIFont(name: helpers.getAppFont(), size: 16)
        self.addSubview(textSuggest)
        
        status = UIImageView(frame: CGRect(x: Int(helpers.screenWidth) - 50, y: 10, width: 40, height: 40))
        self.addSubview(status)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
	
	func setSuggestTitle(text: String!) {
		textSuggest.text = text
	}
}

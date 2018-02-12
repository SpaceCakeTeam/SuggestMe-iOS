class QuestionCell: UITableViewCell {

	var helpers = Helpers.shared

    var category: UIImageView!
    var textSuggest: UILabel!
    var status: UIImageView!

    //MARK: UI methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.6)

        category = UIImageView(frame: CGRect(x: 10, y: 15, width: 30, height: 30))
        self.addSubview(category)

		textSuggest = UILabel(frame: CGRect(x: Int(category.frame.width)+20, y: 0, width: Int(helpers.screenWidth) - 140, height: 60))
		textSuggest.textAlignment = NSTextAlignment.Left
        textSuggest.font = UIFont(name: helpers.getAppFont(), size: 16)
        self.addSubview(textSuggest)

        status = UIImageView(frame: CGRect(x: Int(helpers.screenWidth) - 45, y: 15, width: 30, height: 30))
        self.addSubview(status)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

	func setSuggestTitle(text: String!) {
		textSuggest.text = text
	}
}

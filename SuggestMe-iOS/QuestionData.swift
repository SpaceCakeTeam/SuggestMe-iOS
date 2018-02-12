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
        self.catid = decoder.decodeObjectForKey("catid") as! Int
        self.subcatid = decoder.decodeObjectForKey("subcatid") as! Int
        self.text = decoder.decodeObjectForKey("text") as! String
        self.anon = decoder.decodeObjectForKey("anon") as! Bool
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.catid, forKey: "catid")
        encoder.encodeObject(self.subcatid, forKey: "subcatid")
        encoder.encodeObject(self.text, forKey: "text")
        encoder.encodeObject(self.anon, forKey: "anon")
    }
}

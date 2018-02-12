class Category: NSObject, NSCoding {

	var id: Int!
    var name: String!
    var subcategories: [SubCategory!]!

    init(id: Int!, name: String!, subcategories: [SubCategory!]!) {
        self.id = id
        self.name = name
        self.subcategories = subcategories
    }

    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as! Int
        self.name = decoder.decodeObjectForKey("name") as! String
        self.subcategories = decoder.decodeObjectForKey("subcategories") as! [SubCategory]
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.subcategories, forKey: "subcategories")
    }
}

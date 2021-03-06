class SubCategory: NSObject, NSCoding {

	var id: Int!
    var name: String!

    init(id: Int!, name: String!) {
        self.id = id
        self.name = name
    }

    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as! Int
        self.name = decoder.decodeObjectForKey("name") as! String
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.name, forKey: "name")
    }
}
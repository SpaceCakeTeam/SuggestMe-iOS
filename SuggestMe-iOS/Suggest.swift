class Suggest: NSObject, NSCoding {

	var id: Int!
    var text: String!

    init(id: Int!, text: String!) {
        self.id = id
        self.text = text
    }

    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as! Int
        self.text = decoder.decodeObjectForKey("text") as! String
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.id, forKey: "id")
        encoder.encodeObject(self.text, forKey: "text")
    }
}
struct NftsQuery: Dto {
    let sortField: NftFields?
    
    init(sortBy sortField: NftFields?) {
        self.sortField = sortField
    }
    
    enum CodingKeys: String, CodingKey {
        case sortBy
    }

    func asDictionary() -> [String : String] {
        var dictionary: [String : String] = [:]
        
        if let sortField {
            dictionary[CodingKeys.sortBy.rawValue] = sortField.rawValue;
        }
        
        return dictionary
    }
}

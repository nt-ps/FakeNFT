struct NftsApiQuery: Query {

    private(set) var dictionary: [String: String]
    
    private enum Names: String {
        case sortBy, page, size
    }
    
    init(sortBy sortField: NftFields? = nil, pagination: Pagination? = nil) {
        self.dictionary = [:]
        
        if let sortField {
            self.dictionary[Names.sortBy.rawValue] = sortField.rawValue
        }
        
        if let pagination {
            self.dictionary[Names.page.rawValue] = "\(pagination.page)"
            self.dictionary[Names.size.rawValue] = "\(pagination.size)"
        }
    }
}

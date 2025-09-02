struct NftApiQuery: Query {

    private(set) var dictionary: [String: String]
    
    private enum Names: String {
        case sortBy, page, size
    }
    
    struct Pagination {
        var page: Int
        var size: Int
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

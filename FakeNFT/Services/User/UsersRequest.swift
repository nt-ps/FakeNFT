import Foundation

struct UsersRequest: NetworkRequest {
    var dto: Dto?
    var query: Query?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    
    var httpMethod: HttpMethod = .get
    
    init(page: Int, size: Int, sortBy: String) {
        self.query = UsersQuery(page: page, size: size, sortBy: sortBy)
    }
}

struct UsersQuery: Query {
    let page: Int
    let size: Int
    let sortBy: String
    
    var dictionary: [String: String] {
        return [
            "page": "\(page)",
            "size": "\(size)",
            "sortBy": sortBy
        ]
    }
}

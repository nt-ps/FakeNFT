import Foundation

struct UsersRequest: NetworkRequest {
    var dto: Dto?
    var query: Query?
    
    var endpoint: URL? {
        RequestConstants.Endpoint.users.url
    }
    
    var httpMethod: HttpMethod = .get
    
    init(page: Int){
        self.query = UsersQuery(page: page, size: 10, sortBy: "rating")
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

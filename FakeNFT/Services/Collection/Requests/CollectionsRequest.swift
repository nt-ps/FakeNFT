import Foundation

struct CollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var httpMethod: HttpMethod
    var query: Query?
    var dto: Dto?
    
    init(query: CollectionsApiQuery? = nil) {
        self.httpMethod = .get
        self.query = query
    }
}

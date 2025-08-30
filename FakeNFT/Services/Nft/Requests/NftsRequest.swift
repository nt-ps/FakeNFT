import Foundation

struct NftsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
    var httpMethod: HttpMethod
    var dto: Dto?
    
    init(query: NftsQuery? = nil) {
        self.httpMethod = .get
        self.dto = query
    }
}

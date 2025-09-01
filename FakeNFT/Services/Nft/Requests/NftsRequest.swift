import Foundation

struct NftsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
    var httpMethod: HttpMethod
    var query: Query?
    var dto: Dto?
    
    init(query: NftApiQuery? = nil) {
        self.httpMethod = .get
        self.query = query
    }
}

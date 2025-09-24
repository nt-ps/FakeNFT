import Foundation

struct NftsRequest: NetworkRequest {
    var endpoint: URL? {
        RequestConstants.Endpoint.nfts.url
    }

    var httpMethod: HttpMethod
    var query: Query?
    var dto: Dto?
    
    init(query: NftsApiQuery? = nil) {
        self.httpMethod = .get
        self.query = query
    }
}

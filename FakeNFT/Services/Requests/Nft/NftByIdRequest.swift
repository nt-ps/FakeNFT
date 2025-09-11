import Foundation

struct NftRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        RequestConstants.Endpoint.nftById(id: id).url
    }
    
    var query: Query?
    var dto: Dto?
}

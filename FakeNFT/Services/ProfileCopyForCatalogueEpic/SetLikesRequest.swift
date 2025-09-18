import Foundation

// TODO: Измененная копия SetLikeRequest Амины.
//       Помнить про это при слиянии.

struct SetLikesRequest: NetworkRequest {
    let likes: [String]
    
    var endpoint: URL? {
        RequestConstants.Endpoint.profile.url
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Dto? {
        LikeModel(likes: likes)
    }
    
    var query: (any Query)?
    
    init(likes: [String]) {
        self.likes = likes
    }
}

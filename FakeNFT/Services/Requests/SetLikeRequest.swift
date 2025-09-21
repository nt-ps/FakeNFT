//
//  SetLikeRequest.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import Foundation

struct SetLikeRequest: NetworkRequest {

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

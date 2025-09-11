//
//  SetLikeRequest.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import Foundation

struct SetLikeRequest: NetworkRequest {
    
    let nftId: String
    let isLiked: Bool
    
    var endpoint: URL? {
        RequestConstants.Endpoint.profile.url
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Dto? {
        LikeModel(nftId: nftId, isLiked: isLiked)
    }
    
    var query: (any Query)?
    
    init(nftId: String, isLiked: Bool) {
        self.nftId = nftId
        self.isLiked = isLiked
    }
}

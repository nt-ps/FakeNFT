//
//  GetNFTRequest.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

struct GetNFTRequest: NetworkRequest {
    
    var endpoint: URL? {
        RequestConstants.Endpoint.nfts.url
    }
    
    var httpMethod: HttpMethod {
        .get
    }

    var dto: Dto?
}

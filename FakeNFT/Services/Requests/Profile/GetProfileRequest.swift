//
//  GetProfileRequest.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        RequestConstants.Endpoint.profile.url
    }
    
    var httpMethod: HttpMethod {
        .get
    }

    var dto: Dto?
    var query: Query?
}

//
//  EditProfileRequest.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

struct EditProfileRequest: NetworkRequest {
    let model: EditProfileModel

    var endpoint: URL? {
        RequestConstants.Endpoint.profile.url
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Dto? {
        model
    }

    init(model: EditProfileModel) {
        self.model = model
    }
}

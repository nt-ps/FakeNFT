//
//  EditProfileModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

struct EditProfileModel: Dto {
    let avatar: String
    let name: String
    let description: String
    let website: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatar
        case description
        case website
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.name.rawValue: name,
            CodingKeys.avatar.rawValue: avatar,
            CodingKeys.description.rawValue: description,
            CodingKeys.website.rawValue: website
        ]
    }
}

//
//  ProfileInfoModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

struct ProfileInfoModel: Codable, Equatable, Dto {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name &&
        lhs.avatar == rhs.avatar &&
        lhs.description == rhs.description &&
        lhs.website == rhs.website &&
        Set(lhs.nfts) == Set(rhs.nfts) &&
        Set(lhs.likes) == Set(rhs.likes)
    }
    
    func asDictionary() -> [String: String] {
        let nftsString = nfts.joined(separator: ",")
        let likesString = likes.joined(separator: ",")
        
        return [
            "name": name,
            "avatar": avatar,
            "description": description ?? "",
            "website": website,
            "nfts": nftsString,
            "likes": likesString
        ]
    }
}

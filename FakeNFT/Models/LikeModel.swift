//
//  LikeModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

struct LikeModel: Dto {
    let likes: [String]

    enum CodingKeys: String, CodingKey {
        case likes
    }

    func asDictionary() -> [String: String] {
        let likesString = likes.joined(separator: ",")
        return [
            CodingKeys.likes.rawValue: likesString
        ]
    }
}

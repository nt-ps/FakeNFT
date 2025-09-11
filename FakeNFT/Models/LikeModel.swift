//
//  LikeModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

struct LikeModel: Dto {
    let nftId: String
    let isLiked: Bool
    
    func asDictionary() -> [String: String] {
        return [
            "nft_id": nftId,
            "is_liked": isLiked ? "true" : "false"
        ]
    }
}

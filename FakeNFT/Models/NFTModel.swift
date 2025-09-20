//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

// TODO: Дублируется с Network/Nft.
//       Объединить их в Nft после полной готовности экрана профиля.

import Foundation

struct NFTModel: Decodable {
    let image: String
    let name: String
    let authorName: String
    let rating: Int
    let price: Float
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.image == rhs.image &&
        lhs.name == rhs.name &&
        lhs.authorName == rhs.authorName &&
        lhs.rating == rhs.rating &&
        lhs.price == rhs.price
    }
}

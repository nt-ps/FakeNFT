//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

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

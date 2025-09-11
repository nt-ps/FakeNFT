//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

struct NFTModel: Decodable {
    let name: String
    let image: String
    let rating: Int
    let author: String
    let price: Float
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name &&
        lhs.image == rhs.image &&
        lhs.author == rhs.author &&
        lhs.rating == rhs.rating &&
        lhs.price == rhs.price
    }
}
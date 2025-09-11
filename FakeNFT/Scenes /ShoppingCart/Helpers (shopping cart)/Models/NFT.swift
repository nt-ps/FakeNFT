//
//  NFT.swift
//  FakeNFT
//
//  Created by oneche$$$ on 08.09.2025.
//

import Foundation

struct NFT: Decodable, Hashable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}

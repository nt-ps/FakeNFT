//
//  MockProfileService.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import Foundation
import UIKit

final class MockProfileService: ProfileServiceProtocol {
    
    static let shared = MockProfileService()
    
    private init() {}
    
    func fetchProfile(completion: @escaping (Result<ProfileInfoModel, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let mockProfile = ProfileInfoModel(
                name: "Амина Хуснутдинова",
                avatar: "https://example.com/avatar.jpg",
                description: "Дизайнер и коллекционер NFT",
                website: "https://example.com",
                nfts: ["Archie", "Art", "Nacho", "Tater"],
                likes: ["Archie", "Tater"]
            )
            completion(.success(mockProfile))
        }
    }
    
    func editProfile(_ editProfileModel: EditProfileModel, completion: @escaping (Result<ProfileInfoModel, Error>) -> Void) {
        fetchProfile(completion: completion)
    }
    
    func getNFTs(completion: @escaping (Result<[Nft], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let mockNFTs = [
                Nft(
                    name: "Archie",
                    images: ["local://NftMock/ArchieCover"],
                    coverImage: nil,
                    rating: 2,
                    price: 1.5,
                    id: "archie",
                    author: "John Doe"
                ),
                Nft(
                    name: "Art",
                    images: ["local://NftMock/ArtCover"],
                    coverImage: nil,
                    rating: 3,
                    price: 2.0,
                    id: "art",
                    author: "John Doe"
                ),
                Nft(
                    name: "Nacho",
                    images: ["local://NftMock/NachoCover"],
                    coverImage: nil,
                    rating: 2,
                    price: 1.8,
                    id: "nacho",
                    author: "John Doe"
                ),
                Nft(
                    name: "Tater",
                    images: ["local://NftMock/TaterCover"],
                    coverImage: nil,
                    rating: 4,
                    price: 3.2,
                    id: "tater",
                    author: "John Doe"
                )
            ]
            
            completion(.success(mockNFTs))
        }
    }
}

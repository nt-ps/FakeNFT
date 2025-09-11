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
    
    func getNFTs(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let mockNFTs = [
                Nft(
                    name: "Archie",
                    coverImage: UIImage(resource: .NftMock.archieCover),
                    rating: 2,
                    price: 1.5,
                    id: "Archie"
                ),
                Nft(
                    name: "Art",
                    coverImage: UIImage(resource: .NftMock.artCover),
                    rating: 3,
                    price: 2.0,
                    id: "Art"
                ),
                Nft(
                    name: "Nacho",
                    coverImage: UIImage(resource: .NftMock.nachoCover),
                    rating: 2,
                    price: 1.8,
                    id: "Nacho"
                ),
                Nft(
                    name: "Tater",
                    coverImage: UIImage(resource: .NftMock.taterCover),
                    rating: 4,
                    price: 3.2,
                    id: "Tater"
                )
            ]
            
            let nftModels = mockNFTs.map { nft in
                NFTModel(
                    name: nft.name,
                    image: "local://NftMock/\(nft.name)Cover",
                    rating: nft.rating,
                    author: "John Doe",
                    price: nft.price
                )
            }
            
            completion(.success(nftModels))
        }
    }
}

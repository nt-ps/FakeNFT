//
//  EmptyMockProfileService.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import Foundation

final class EmptyMockProfileService: ProfileServiceProtocol {
    
    static let shared = EmptyMockProfileService()
    
    private init() {}
    
    func fetchProfile(completion: @escaping (Result<ProfileInfoModel, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let mockProfile = ProfileInfoModel(
                name: "Амина Хуснутдинова",
                avatar: "https://example.com/avatar.jpg",
                description: "Дизайнер и коллекционер NFT",
                website: "https://example.com",
                nfts: [],
                likes: []
            )
            completion(.success(mockProfile))
        }
    }
    
    func editProfile(_ editProfileModel: EditProfileModel, completion: @escaping (Result<ProfileInfoModel, Error>) -> Void) {
        fetchProfile(completion: completion)
    }
    
    func getNFTs(completion: @escaping (Result<[Nft], Error>) -> Void) {
        // Имитируем задержку сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion(.success([]))
        }
    }
}

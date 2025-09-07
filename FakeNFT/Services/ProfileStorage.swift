//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

final class ProfileStorage {

    // MARK: Properties
    static let shared = ProfileStorage()
    var onProfileInfoChanged: (() -> Void)?
    
    private var cachedProfile: ProfileInfoModel?
    private var lastCacheTime: Date?
    private let cacheLifetime: TimeInterval = 300 // 5 минут

    var profile: ProfileInfoModel? {
        get {
            if let cached = cachedProfile, 
               let lastTime = lastCacheTime,
               Date().timeIntervalSince(lastTime) < cacheLifetime {
                print("Using cached profile")
                return cached
            }
            
            guard let data = userDefaults.data(forKey: Keys.profile.rawValue),
                  let record = try? JSONDecoder().decode(ProfileInfoModel.self, from: data) else { 
                return nil 
            }
            
            cachedProfile = record
            lastCacheTime = Date()
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            cachedProfile = newValue
            lastCacheTime = Date()
            
            userDefaults.set(data, forKey: Keys.profile.rawValue)
            onProfileInfoChanged?()
        }
    }
    
    private enum Keys: String {
        case profile
    }

    private let userDefaults = UserDefaults.standard

    // MARK: Initializers
    private init() {}
}

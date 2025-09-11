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
    private let cacheLifetime: TimeInterval = 300

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
    
    var sortType: SortType {
        get {
            guard
                let sortTypeString = userDefaults.string(forKey: Keys.sortType.rawValue),
                let sortType = SortType(rawValue: sortTypeString)
            else {
                return .byRating
            }
            return sortType
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: Keys.sortType.rawValue)
        }
    }
    
    private enum Keys: String {
        case profile
        case sortType
    }

    private let userDefaults = UserDefaults.standard

    // MARK: Initializers
    private init() {}
}

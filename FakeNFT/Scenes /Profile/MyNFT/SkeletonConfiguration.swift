//
//  SkeletonConfiguration.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import Foundation

struct SkeletonConfiguration {
    
    // MARK: - Constants
    static let defaultRowsCount = 3
    
    // MARK: - Methods
    static func getRowsCount(for screen: ScreenType) -> Int {
        switch screen {
        case .myNFT:
            return defaultRowsCount
        case .favouriteNFT:
            return defaultRowsCount
        case .catalog:
            return 6 // Больше элементов в каталоге
        }
    }
}

// MARK: - Screen Types
enum ScreenType {
    case myNFT
    case favouriteNFT
    case catalog
}

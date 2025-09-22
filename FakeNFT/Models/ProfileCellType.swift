//
//  ProfileCellType.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

enum ProfileCellType {
    case myNFT(Int)
    case favouriteNFT(Int)

    var name: String {
        switch self {
        case .myNFT(let number): return L10n.Profile.MyNFT.title + " (\(number))"
        case .favouriteNFT(let number): return L10n.Profile.FavouriteNFT.title + " (\(number))"
        }
    }
}

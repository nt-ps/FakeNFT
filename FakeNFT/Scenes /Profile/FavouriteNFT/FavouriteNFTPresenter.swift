//
//  FavouriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 21.09.2025.
//

import UIKit

protocol FavouriteNFTPresenterProtocol {
    func viewDidLoad()
}

final class FavouriteNFTPresenter: FavouriteNFTPresenterProtocol {
    
    // MARK: Properties
    private weak var view: FavouriteNFTViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileStorage: ProfileStorage = .shared
    
    private var nftList: [Nft] = []
    private var loadedNFTs: [Nft] = []
    private var isLoading: Bool = true
    
    // MARK: Initializers
    init(view: FavouriteNFTViewProtocol, profileService: ProfileServiceProtocol = ProfileService.shared) {
        self.view = view
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        isLoading = true
        view?.showLoading()
        fetchNFTs()
    }
    
    private func fetchNFTs() {
        profileService.getFavouriteNFTs() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let nftModels):
                    self.loadedNFTs = nftModels
                    self.nftList = nftModels
                    
                    if nftModels.isEmpty {
                        self.view?.showEmptyState()
                    } else {
                        self.view?.showNFTs(self.nftList)
                    }
                    
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func getNFTCount() -> Int {
        return nftList.count
    }
    
    func getNFT(at index: Int) -> Nft? {
        guard index < nftList.count else { return nil }
        return nftList[index]
    }
    
    func shouldShowSkeleton() -> Bool {
        return isLoading
    }
}

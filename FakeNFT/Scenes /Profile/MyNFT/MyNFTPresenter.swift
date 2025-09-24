//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit

private let USE_EMPTY_MOCK_DATA = false

protocol MyNFTPresenterProtocol {
    func viewDidLoad()
    func didTapSort()
    func didSelectSortType(_ type: SortType)
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    
    // MARK: Properties
    private weak var view: MyNFTViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileStorage: ProfileStorage = .shared
    
    private var nftList: [Nft] = []
    private var loadedNFTs: [Nft] = []
    private var isLoading: Bool = true
    
    // MARK: Initializers
    init(view: MyNFTViewProtocol, profileService: ProfileServiceProtocol = ProfileService.shared) {
        self.view = view
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        isLoading = true
        view?.showLoading()
        view?.updateSortButtonState(isEnabled: false)
        fetchNFTs()
    }
    
    func didTapSort() {
        let alertModel = AlertModel.sortActionSheet(
            priceCompletion: { [weak self] in
                self?.didSelectSortType(.byPrice)
            },
            ratingCompletion: { [weak self] in
                self?.didSelectSortType(.byRating)
            },
            nameCompletion: { [weak self] in
                self?.didSelectSortType(.byName)
            }
        )
        
        if let viewController = view as? UIViewController {
            AlertPresenter.present(in: viewController, model: alertModel)
        }
    }
    
    func didSelectSortType(_ type: SortType) {
        profileStorage.sortType = type
        sortNFTList()
        view?.showNFTs(nftList)
    }
    
    private func fetchNFTs() {
        profileService.getNFTs { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let nftModels):
                    self.loadedNFTs = nftModels
                    self.nftList = nftModels
                    self.sortNFTList()
                    
                    if nftModels.isEmpty {
                        self.view?.showEmptyState()
                    } else {
                        self.view?.showNFTs(self.nftList)
                    }
                    self.view?.updateSortButtonState(isEnabled: true)
                    
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                    self.view?.updateSortButtonState(isEnabled: false)
                }
            }
        }
    }
    
    private func sortNFTList() {
        let sortType = profileStorage.sortType
        
        switch sortType {
        case .byPrice:
            nftList.sort { $0.price > $1.price }
        case .byRating:
            nftList.sort { $0.rating > $1.rating }
        case .byName:
            nftList.sort { $0.name < $1.name }
        default:
            break
        }
    }
    
    func getNFTCount() -> Int {
        return nftList.count
    }
    
    func getNFT(at index: Int) -> Nft? {
        index < nftList.count ? nftList[index] : nil
    }
    
    func shouldShowSkeleton() -> Bool {
        return isLoading
    }
}

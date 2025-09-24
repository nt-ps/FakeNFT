//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation

protocol ShoppingCartModelProtocol: AnyObject {
    var NFTsInCart: [Nft] { get set }
    var chosenSortMethod: String { get set }
    func getOrder()
    func postNewOrderWithoutDeletedNFT()
    func sortOrderBy(_ parameter: String)
}

final class ShoppingCartModelImplementation: ShoppingCartModelProtocol {
    //MARK: Presenter
    weak var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    
    var NFTsInCart: [Nft] = [] {
        didSet {
            NFTsInCartTotalPrice = 0
            for nft in NFTsInCart {
                NFTsInCartTotalPrice += nft.price
            }
            NFTsInCartTotalPrice = (NFTsInCartTotalPrice * 100).rounded() / 100
            totalNFTsAmount = NFTsInCart.count
            shoppingCartPresenter?.reloadCartInUI(nfts: NFTsInCart, totalNFTsPrice: NFTsInCartTotalPrice, totalNFTsAmount: totalNFTsAmount)
        }
    }
    var chosenSortMethod: String {
        get { localStorage.shoppingCartSortMethod }
        set { localStorage.shoppingCartSortMethod = newValue }
    }

    private var NFTsInCartTotalPrice: Float = 0
    private var totalNFTsAmount: Int = 0
    
    private let orderService: OrderServiceProtocol
    private let nftService: NftService
    
    private var localStorage: LocalStorageProtocol
    
    init(
        servicesAssembler: ServicesAssembly,
        localStorage: LocalStorageProtocol
    ) {
        self.orderService = servicesAssembler.orderService
        self.nftService = servicesAssembler.nftService
        self.localStorage = localStorage
    }
    
    func getOrder() {
        orderService.fetchOrder() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                guard order.nfts.count != 0 else {
                    shoppingCartPresenter?.showPlaceholderIf(needed: true)
                    return
                }
                for nft in order.nfts {
                    getNFTByID(id: nft)
                }
                shoppingCartPresenter?.showPlaceholderIf(needed: false)
            case .failure:
                shoppingCartPresenter?.showPlaceholderIf(needed: true)
            }
        }
    }
    
    func postNewOrderWithoutDeletedNFT() {
        let NFTsInCartNames = NFTsInCart.map { $0.id }
        orderService.postNewOrder(with: NFTsInCartNames) { _ in }
    }
    
    func sortOrderBy(_ parameter: String) {
        switch parameter {
        case L10n.SortAlert.byPrice:
            chosenSortMethod = L10n.SortAlert.byPrice
            NFTsInCart = NFTsInCart.sorted { $0.price < $1.price }
        case L10n.SortAlert.byRating:
            chosenSortMethod = L10n.SortAlert.byRating
            NFTsInCart = NFTsInCart.sorted { $0.rating > $1.rating }
        default:
            chosenSortMethod = L10n.SortAlert.byName
            NFTsInCart = NFTsInCart.sorted { $0.name < $1.name }
        }
    }
    
    private func getNFTByID(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            switch result {
            case .success(let nft):
                guard let self else { return }
                self.NFTsInCart.append(nft)
                sortOrderBy(chosenSortMethod)
                break
            case .failure(let error):
                print("[\(#function)] Failed to load NFT: \(error.localizedDescription).")
                break
            }
        }
    }
}


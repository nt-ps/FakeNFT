//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation

protocol ShoppingCartModelProtocol: AnyObject {
    var NFTsInCart: [NFT] { get set }
    var chosenSortMethod: String { get set }
    func getOrder()
    func postNewOrderWithoutDeletedNFT()
    func sortOrderBy(_ parameter: String)
}

final class ShoppingCartModelImplementation: ShoppingCartModelProtocol {
    //MARK: Presenter
    weak var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    
    var NFTsInCart: [NFT] = [] {
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
        get {
            UserDefaults.standard.string(forKey: "chosenSortMethod") ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: "chosenSortMethod")
        }
    }

    private var NFTsInCartTotalPrice: Float = 0
    private var totalNFTsAmount: Int = 0
    
    private let orderService: OrderServiceProtocol?
    private let NFTByIDService: NFTByIDServiceProtocol?
    private let postNewShoppingCartService: PutNewOrderServiceProtocol?
    
    init() {
        self.orderService = OrderServiceImplementation()
        self.NFTByIDService = NFTByIDServiceImplementation()
        self.postNewShoppingCartService = PutNewOrderServiceImplementation()
    }
    
    func getOrder() {
        orderService?.fetchOrder() { [weak self] result in
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
        let NFTsInCartNames = NFTsInCart.map { $0.name }
        postNewShoppingCartService?.postNewOrder(with: NFTsInCartNames) { _ in }
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
        NFTByIDService?.getNFTByID(id: id) { [weak self] nft in
            guard let self else { return }
            self.NFTsInCart.append(nft)
            sortOrderBy(chosenSortMethod)
        }
    }
}


//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit



protocol ShoppingCartModelProtocol: AnyObject {
    var NFTsInCart: [NFT] { get set }
    func getOrder()
    func postNewOrderWithoutDeletedNFT()
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
        orderService?.fetchOrder() { [weak self] order in
            guard let self else { return }
            guard order.nfts.count != 0 else {
                shoppingCartPresenter?.showPlaceholderIf(needed: true)
                return
            }
            for nft in order.nfts {
                getNFTByID(id: nft)
            }
            shoppingCartPresenter?.showPlaceholderIf(needed: false)
        }
    }
    
    func postNewOrderWithoutDeletedNFT() {
        postNewShoppingCartService?.postNewOrder(with: NFTsInCart)
    }
    
    private func getNFTByID(id: String) {
        NFTByIDService?.getNFTByID(id: id) { [weak self] nft in
            guard let self else { return }
            NFTsInCart.append(nft)
        }
    }
}


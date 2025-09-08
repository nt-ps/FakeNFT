//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit



protocol ShoppingCartModelProtocol: AnyObject {
    func getOrder()
    var NFTsInCart: [NFT] { get set }
}



final class ShoppingCartModelImplementation: ShoppingCartModelProtocol {
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
    
    init() {
        self.orderService = OrderServiceImplementation()
        self.NFTByIDService = NFTByIDServiceImplementation()
    }
    
    func getOrder() {
        orderService?.fetchOrder() { [weak self] order in
            guard let self else { return }
            for nft in order.nfts {
                getNFTByID(id: nft)
            }
        }
    }
    
    private func getNFTByID(id: String) {
        NFTByIDService?.getNFTByID(id: id) { [weak self] nft in
            guard let self else { return }
            NFTsInCart.append(nft)
        }
    }
}


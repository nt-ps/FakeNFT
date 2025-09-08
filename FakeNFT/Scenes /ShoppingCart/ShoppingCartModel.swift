//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit



protocol ShoppingCartModelProtocol: AnyObject {
    func getOrder()
    var nftsInCart: [NFT] { get set }
}



final class ShoppingCartModelImplementation: ShoppingCartModelProtocol {
    weak var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    var nftsInCart: [NFT] = [] {
        didSet {
            shoppingCartPresenter?.reloadCartInUI(nfts: nftsInCart)
        }
    }
    
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
            nftsInCart.append(nft)
        }
    }
    
    private func calculateCartInfo
}

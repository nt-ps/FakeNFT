//
//  ShoppingCartPresenter.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation



protocol ShoppingCartPresenterProtocol: AnyObject {
    func getOrder()
    func reloadCartInUI(nfts: [NFT])
    func getNFTs() -> [NFT]
    func clearNftsInCart()
}



final class ShoppingCartPresenterImplementation: ShoppingCartPresenterProtocol {
    private weak var shoppingCartView: ShoppingCartViewProtocol?
    private let shoppingCartModel: ShoppingCartModelProtocol
    
    init(shoppingCartView: ShoppingCartViewProtocol, shoppingCartModel: ShoppingCartModelProtocol) {
        self.shoppingCartView = shoppingCartView
        self.shoppingCartModel = shoppingCartModel
    }
    
    func getNFTs() -> [NFT] {
        shoppingCartModel.nftsInCart
    }
    
    func getOrder() {
        shoppingCartModel.getOrder()
    }
    
    func reloadCartInUI(nfts: [NFT]) {
        shoppingCartView?.applySnapshotForTableView(nfts: nfts)
    }
    
    func clearNftsInCart() {
        shoppingCartModel.nftsInCart = []
    }
}

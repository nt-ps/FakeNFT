//
//  ShoppingCartPresenter.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation

protocol ShoppingCartPresenterProtocol: AnyObject {
    func getOrder()
    func reloadCartInUI(nfts: [NFT], totalNFTsPrice: Float, totalNFTsAmount: Int)
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
        shoppingCartModel.NFTsInCart
    }
    
    func getOrder() {
        shoppingCartModel.getOrder()
    }
    
    func reloadCartInUI(nfts: [NFT], totalNFTsPrice: Float, totalNFTsAmount: Int) {
        shoppingCartView?.reloadDataInTableView(nfts: nfts, totalNFTsPrice: totalNFTsPrice, totalNFTsAmount: totalNFTsAmount)
    }
    
    func clearNftsInCart() {
        shoppingCartModel.NFTsInCart = []
    }
}

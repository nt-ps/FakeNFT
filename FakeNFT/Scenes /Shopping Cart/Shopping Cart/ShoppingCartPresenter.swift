//
//  ShoppingCartPresenter.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation

protocol ShoppingCartPresenterProtocol: AnyObject {
    var NFTsToDeleteName: String { get set }
    func getOrder()
    func reloadCartInUI(nfts: [NFT], totalNFTsPrice: Float, totalNFTsAmount: Int)
    func getNFTs() -> [NFT]
    func clearNftsInCart()
    func deleteNFTFromCart()
    func showPlaceholderIf(needed: Bool)
    func sortOrderBy(_ parameter: String)
}

final class ShoppingCartPresenterImplementation: ShoppingCartPresenterProtocol {
    // MARK: View and Model
    private weak var shoppingCartView: ShoppingCartViewProtocol?
    private let shoppingCartModel: ShoppingCartModelProtocol
    
    var NFTsToDeleteName: String = ""
    
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
    
    func deleteNFTFromCart() {
        shoppingCartModel.NFTsInCart.removeAll(where: { $0.name == NFTsToDeleteName })
        if shoppingCartModel.NFTsInCart.isEmpty {
            shoppingCartView?.showPlaceholderIf(needed: true)
        }
        shoppingCartModel.postNewOrderWithoutDeletedNFT()
    }
    
    func showPlaceholderIf(needed: Bool) {
        shoppingCartView?.showPlaceholderIf(needed: needed)
    }
    
    func sortOrderBy(_ parameter: String) {
        shoppingCartModel.sortOrderBy(parameter)
    }
}

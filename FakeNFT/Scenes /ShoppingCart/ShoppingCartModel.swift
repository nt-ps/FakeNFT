//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation



protocol ShoppingCartModelProtocol: AnyObject {
    
}



final class ShoppingCartModelImplementation: ShoppingCartModelProtocol {
    weak var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    private let servicesAssembly: ServicesAssembly
    
    
    // MARK: МОКОВЫЙ МАССИВ НФТ (позже удалить)
    private var nfts: [Nft] = [
        .init(name: "Test NFT 1", coverImage: "https://via.placeholder.com/150", rating: 4.5, price: 1000000000000000000, id: "1"),
        .init(name: "Test NFT 2", coverImage: "https://via.placeholder.com/150", rating: 4.5, price: 200000
              )]
    
    
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
}

//
//  ShoppingCartModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit



protocol ShoppingCartModelProtocol: AnyObject {
    
}



final class ShoppingCartModelImplementation: ShoppingCartModelProtocol {
    weak var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    private let servicesAssembly: ServicesAssembly
    
    
    
    // MARK: МОКОВЫЙ МАССИВ НФТ (позже удалить)
    private var nfts: [Nft] = [.init(name: "первый нфт", coverImage: UIImage(), rating: 3, price: 12451525, id: "some id 1"),
                               .init(name: "второй нфт", coverImage: UIImage(), rating: 5, price: 124999, id: "some id 2")
    ]
    
    
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
}

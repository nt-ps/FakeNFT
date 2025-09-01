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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
}

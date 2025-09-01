//
//  ShoppingCartPresenter.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import Foundation



protocol ShoppingCartPresenterProtocol: AnyObject {
    
}



final class ShoppingCartPresenterImplementation: ShoppingCartPresenterProtocol {
    private let shoppingCartView: ShoppingCartViewProtocol
    private let shoppingCartModel: ShoppingCartModelProtocol
    
    init(shoppingCartView: ShoppingCartViewProtocol, shoppingCartModel: ShoppingCartModelProtocol) {
        self.shoppingCartView = shoppingCartView
        self.shoppingCartModel = shoppingCartModel
    }
}

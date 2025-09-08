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
    private let orderService: OrderServiceProtocol?
    private var order: Order? {
        didSet {
            
        }
    }
    
    init() {
        self.orderService = OrderServiceImplementation()
    }
    
}

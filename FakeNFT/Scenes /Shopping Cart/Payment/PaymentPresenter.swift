//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import Foundation

protocol PaymentPresenterProtocol: AnyObject {
    func getCurrencies() -> [Currency]
    func loadCurrenciesFromServer()
    func reloadCurrenciesCollectionInUI()
    func clearCurrencies()
}

final class PaymentPresenter: PaymentPresenterProtocol {
    // MARK: View and model
    private weak var paymentView: PaymentViewProtocol?
    private let paymentModel: PaymentModelProtocol
    
    init(paymentView: PaymentViewProtocol, paymentModel: PaymentModelProtocol) {
        self.paymentView = paymentView
        self.paymentModel = paymentModel
    }
    
    func getCurrencies() -> [Currency] { paymentModel.currencies }
    
    func loadCurrenciesFromServer() {
        paymentModel.fetchCurrencies()
    }
    
    func reloadCurrenciesCollectionInUI() {
        paymentView?.reloadCurrenciesCollectionView(currencies: paymentModel.currencies)
    }
    
    func clearCurrencies() {
        paymentModel.currencies.removeAll()
    }
}

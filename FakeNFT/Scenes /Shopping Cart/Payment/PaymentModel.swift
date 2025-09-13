//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import Foundation

protocol PaymentModelProtocol: AnyObject {
    var currencies: [Currency] { get set }
    func fetchCurrencies()
}

final class PaymentModel: PaymentModelProtocol {
    // MARK: Presenter
    weak var paymentPresenter: PaymentPresenterProtocol?
    
    var currencies: [Currency] = []
    
    private let currenciesService: CurrenciesServiceProtocol
    
    init() {
        self.currenciesService = CurrenciesService()
    }
    
    func fetchCurrencies() {
        currenciesService.fetchCurrencies() { [weak self] fetchedCurrencies in
            guard let self else { return }
            self.currencies = fetchedCurrencies
            paymentPresenter?.reloadCurrenciesCollectionInUI()
        }
    }
}

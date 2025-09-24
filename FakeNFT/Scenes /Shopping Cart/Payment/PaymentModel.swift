//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import Foundation

protocol PaymentModelProtocol: AnyObject {
    var currencies: [Currency] { get set }
    var selectedCurrencyID: String { get set }
    func fetchCurrencies()
    func payOrder()
}

final class PaymentModel: PaymentModelProtocol {
    // MARK: Presenter
    weak var paymentPresenter: PaymentPresenterProtocol?
    
    var currencies: [Currency] = []
    var selectedCurrencyID = ""
    
    private let currenciesService: CurrenciesServiceProtocol
    private let paymentService: PaymentServiceProtocol
    private let orderService: OrderServiceProtocol
    
    init(servicesAssembler: ServicesAssembly) {
        self.currenciesService = servicesAssembler.currenciesService
        self.paymentService = servicesAssembler.paymentService
        self.orderService = servicesAssembler.orderService
    }
    
    func fetchCurrencies() {
        currenciesService.fetchCurrencies() { [weak self] fetchedCurrencies in
            guard let self else { return }
            self.currencies = fetchedCurrencies
            paymentPresenter?.reloadCurrenciesCollectionInUI()
        }
    }
    
    func payOrder() {
        paymentService.payOrderWithCurrencyID(selectedCurrencyID) { [weak self] payment in
            guard let self else { return }
            if let payment, payment.success == true {
                self.clearOrder()
                self.paymentPresenter?.showPaymentSucceed()
            } else {
                self.paymentPresenter?.showPaymentFailedAlert()
                return
            }
        }
    }
    
    private func clearOrder() {
        orderService.postNewOrder(with: []) { _ in }
    }
}

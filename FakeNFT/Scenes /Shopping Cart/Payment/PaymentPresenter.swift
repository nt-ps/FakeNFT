//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import Foundation

protocol PaymentPresenterProtocol: AnyObject {
    
}

final class PaymentPresenter: PaymentPresenterProtocol {
    private weak var paymentView: PaymentViewProtocol?
    private let paymentModel: PaymentModelProtocol? = nil
}

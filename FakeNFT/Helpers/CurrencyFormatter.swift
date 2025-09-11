//
//  CurrencyFormatter.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 08.09.2025.
//

import Foundation

final class CurrencyFormatter: NumberFormatter, @unchecked Sendable {
    static let shared = CurrencyFormatter()

    private override init() {
        super.init()
        numberStyle = .currency
        maximumFractionDigits = 3
        currencyCode = "ETH"
        locale = .current
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

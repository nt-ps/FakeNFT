//
//  PaymentView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import UIKit



protocol PaymentViewProtocol: AnyObject {
    
}



final class PaymentViewController: UIViewController, PaymentViewProtocol {
    var paymentPresenter: PaymentPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}



private extension PaymentViewController {
    private func setupView() {
        
    }
}

#Preview {
    PaymentViewController()
}

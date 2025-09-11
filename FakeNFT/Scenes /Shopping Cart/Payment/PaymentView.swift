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
    
    // MARK: UI Elements
    private let paymentLabel = UILabel()
    private lazy var currenciesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: currenciesCollectionViewFlowLayout)
    private let bottomBackgroundView = UIView()
    private let payButton = UIButton()
    private let userAgreementLabel = UILabel()
    private let userAgreementButton = UIButton()
    
    private let currenciesCollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: setupView
private extension PaymentViewController {
    private func setupView() {
        setUpPaymentLabel()
        setUpCurrenciesCollectionView()
        setUpBottomBackgroundView()
        setUpPayButton()
        setUpUserAgreementLabel()
        setUpUserAgreementButton()
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(hexString: "#1A1B22")
            navigationController?.navigationBar.tintColor = .white
        } else {
            view.backgroundColor = .white
            navigationItem.backBarButtonItem?.tintColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpPaymentLabel() {
        paymentLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentLabel)
        if let navigationBar = navigationController?.navigationBar, navigationBar.superview != view {
            view.addSubview(navigationBar)
        }
        guard let navigationBarCenterYAnchor = navigationController?.navigationBar.centerYAnchor else { return }
        NSLayoutConstraint.activate([
            paymentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentLabel.centerYAnchor.constraint(equalTo: navigationBarCenterYAnchor),
            paymentLabel.widthAnchor.constraint(equalToConstant: 261),
            paymentLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        paymentLabel.numberOfLines = 1
        paymentLabel.textAlignment = .center
        paymentLabel.font = .systemFont(ofSize: 17, weight: .bold)
        paymentLabel.text = L10n.Payment.title
        if traitCollection.userInterfaceStyle == .dark {
            paymentLabel.textColor = .white
        } else {
            paymentLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpCurrenciesCollectionView() {
        currenciesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currenciesCollectionView)
        NSLayoutConstraint.activate([
            currenciesCollectionView.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 30),
            currenciesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currenciesCollectionView.widthAnchor.constraint(equalToConstant: 343),
            currenciesCollectionView.heightAnchor.constraint(equalToConstant: 205)
        ])
        currenciesCollectionView.backgroundColor = .red
    }
    
    private func setUpBottomBackgroundView() {
        bottomBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBackgroundView)
        NSLayoutConstraint.activate([
            bottomBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackgroundView.heightAnchor.constraint(equalToConstant: 186)
        ])
        if traitCollection.userInterfaceStyle == .dark {
            bottomBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
        } else {
            bottomBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
        }
        bottomBackgroundView.layer.masksToBounds = true
        bottomBackgroundView.layer.cornerRadius = 12
        bottomBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setUpPayButton() {
        payButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.widthAnchor.constraint(equalToConstant: 343),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        payButton.layer.masksToBounds = true
        payButton.layer.cornerRadius = 16
        payButton.setTitle(L10n.Payment.pay, for: .normal)
        payButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        if traitCollection.userInterfaceStyle == .dark {
            payButton.setTitleColor(UIColor(hexString: "#1A1B22"), for: .normal)
            payButton.backgroundColor = .white
        } else {
            payButton.setTitleColor(.white, for: .normal)
            payButton.backgroundColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpUserAgreementLabel() {
        userAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userAgreementLabel)
        NSLayoutConstraint.activate([
            userAgreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementLabel.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 16),
            userAgreementLabel.widthAnchor.constraint(equalToConstant: 380),
            userAgreementLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        userAgreementLabel.numberOfLines = 1
        userAgreementLabel.font = .systemFont(ofSize: 13, weight: .regular)
        userAgreementLabel.textAlignment = .left
        if Locale.current.languageCode == "ru" {
            userAgreementLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        } else {
            userAgreementLabel.text = "By making a purchase, you agree to the terms of the"
        }
        if traitCollection.userInterfaceStyle == .dark {
            userAgreementLabel.textColor = .white
        } else {
            userAgreementLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpUserAgreementButton() {
        userAgreementButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userAgreementButton)
        NSLayoutConstraint.activate([
            userAgreementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementButton.topAnchor.constraint(equalTo: userAgreementLabel.bottomAnchor),
            userAgreementButton.widthAnchor.constraint(equalToConstant: 202),
            userAgreementButton.heightAnchor.constraint(equalToConstant: 26)
        ])
        userAgreementButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        userAgreementButton.setTitleColor(UIColor(hexString: "#0A84FF"), for: .normal)
        userAgreementButton.contentHorizontalAlignment = .left
        if Locale.current.languageCode == "ru" {
            userAgreementButton.setTitle("Пользовательского соглашения", for: .normal)
        } else {
            userAgreementButton.setTitle("User agreement", for: .normal)
        }
    }
}

// MARK: Dark theme implementation
extension PaymentViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(hexString: "#1A1B22")
            navigationController?.navigationBar.tintColor = .white
            paymentLabel.textColor = .white
            bottomBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
            payButton.setTitleColor(UIColor(hexString: "#1A1B22"), for: .normal)
            payButton.backgroundColor = .white
            userAgreementLabel.textColor = .white
        } else {
            view.backgroundColor = .white
            navigationItem.backBarButtonItem?.tintColor = UIColor(hexString: "#1A1B22")
            paymentLabel.textColor = UIColor(hexString: "#1A1B22")
            bottomBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
            payButton.setTitleColor(.white, for: .normal)
            payButton.backgroundColor = UIColor(hexString: "#1A1B22")
            userAgreementLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
}

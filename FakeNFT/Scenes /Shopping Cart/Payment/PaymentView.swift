//
//  PaymentView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import UIKit

protocol PaymentViewProtocol: AnyObject {
    func reloadCurrenciesCollectionView(currencies: [Currency])
    func showPaymentFailedAlert()
}

final class PaymentViewController: UIViewController, PaymentViewProtocol {
    // MARK: Presenter
    var paymentPresenter: PaymentPresenterProtocol?
    
    // MARK: UI Elements
    private lazy var currenciesCollectionView: UICollectionView = {
        let currenciesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: currenciesCollectionViewFlowLayout)
        currenciesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        currenciesCollectionView.isScrollEnabled = false
        currenciesCollectionView.backgroundColor = .clear
        currenciesCollectionView.register(CurrenciesCollectionViewCell.self, forCellWithReuseIdentifier: "currenciesCollectionViewCell")
        return currenciesCollectionView
    }()
    private lazy var bottomBackgroundView: UIView = {
        let bottomBackgroundView = UIView()
        bottomBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bottomBackgroundView.backgroundColor = .AppColors.lightGray
        bottomBackgroundView.layer.masksToBounds = true
        bottomBackgroundView.layer.cornerRadius = 12
        bottomBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bottomBackgroundView
    }()
    private lazy var payButton: UIButton = {
        let payButton = UIButton()
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.layer.masksToBounds = true
        payButton.layer.cornerRadius = 16
        payButton.setTitle(L10n.Payment.pay, for: .normal)
        payButton.titleLabel?.font = .bodyBold
        payButton.backgroundColor = .AppColors.black
        payButton.setTitleColor(.AppColors.white, for: .normal)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        payButton.isEnabled = false
        return payButton
    }()
    private lazy var userAgreementLabel: UILabel = {
        let userAgreementLabel = UILabel()
        userAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
        userAgreementLabel.numberOfLines = 1
        userAgreementLabel.font = .caption2
        userAgreementLabel.textAlignment = .left
        if Locale.current.languageCode == "ru" {
            userAgreementLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        } else {
            userAgreementLabel.text = "By making a purchase, you agree to the terms of the"
        }
        userAgreementLabel.textColor = .AppColors.black
        return userAgreementLabel
    }()
    private lazy var userAgreementButton: UIButton = {
        let userAgreementButton = UIButton()
        userAgreementButton.translatesAutoresizingMaskIntoConstraints = false
        userAgreementButton.titleLabel?.font = .caption2
        userAgreementButton.setTitleColor(UIColor(hexString: "#0A84FF"), for: .normal)
        userAgreementButton.contentHorizontalAlignment = .left
        if Locale.current.languageCode == "ru" {
            userAgreementButton.setTitle("Пользовательского соглашения", for: .normal)
        } else {
            userAgreementButton.setTitle("User agreement", for: .normal)
        }
        userAgreementButton.addTarget(self, action: #selector(userAgreementButtonTapped), for: .touchUpInside)
        return userAgreementButton
    }()
    
    private lazy var currenciesCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let currenciesCollectionViewFlowLayout = UICollectionViewFlowLayout()
        currenciesCollectionViewFlowLayout.itemSize = CGSize(width: 168, height: 46)
        currenciesCollectionViewFlowLayout.minimumLineSpacing = 7
        currenciesCollectionViewFlowLayout.minimumInteritemSpacing = 7
        return currenciesCollectionViewFlowLayout
    }()
    private lazy var currenciesCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Int, Currency>(collectionView: currenciesCollectionView) { [weak self] collectionView, indexPath, itemIdentifier in
        guard let self,
              let cell = self.currenciesCollectionView.dequeueReusableCell(withReuseIdentifier: "currenciesCollectionViewCell", for: indexPath) as? CurrenciesCollectionViewCell
        else { return UICollectionViewCell() }
        guard let currencies = paymentPresenter?.getCurrencies() else { return UICollectionViewCell() }
        cell.configureCell(currency: currencies[indexPath.item])
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currenciesCollectionView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        paymentPresenter?.clearCurrencies()
        let snapshot = NSDiffableDataSourceSnapshot<Int, Currency>()
        currenciesCollectionViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        paymentPresenter?.loadCurrenciesFromServer()
        ProgressHUDProvider.showProgressHUD()
    }
    
    func reloadCurrenciesCollectionView(currencies: [Currency]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Currency>()
            snapshot.appendSections([0])
            snapshot.appendItems(currencies)
            self.currenciesCollectionViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
        }
        ProgressHUDProvider.dismissProgressHUD()
    }
    
    func showPaymentFailedAlert() {
        let alert = UIAlertController(title: L10n.Payment.FailureAlert.title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L10n.Payment.FailureAlert.cancel, style: .cancel) { _ in }
        let repeatAction = UIAlertAction(title: L10n.Payment.FailureAlert.repeat, style: .default) { [weak self] _ in
            self?.paymentPresenter?.makePayment()
        }
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        alert.preferredAction = repeatAction
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    // MARK: UI Actions
    @objc private func userAgreementButtonTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse") else { return }
        let request = URLRequest(url: url)
        let webViewController = WebViewAssembly().build(with: request)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func payButtonTapped() {
        paymentPresenter?.makePayment()
    }
}

// MARK: currenciesCollectionView delegate
extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        payButton.isEnabled = true
        guard let selectedCell = currenciesCollectionView.cellForItem(at: indexPath) as? CurrenciesCollectionViewCell,
        let currencies = paymentPresenter?.getCurrencies()
        else { return }
        paymentPresenter?.setSelectedCurrencyID(currencies[indexPath.item].id)
        selectedCell.borderView.isHidden = false
        for counter in 0...currencies.count {
            guard let cellToDeselect = currenciesCollectionView.cellForItem(at: IndexPath(item: counter, section: 0)) as? CurrenciesCollectionViewCell else { return }
            if cellToDeselect != selectedCell {
                cellToDeselect.borderView.isHidden = true
            }
        }
    }
}

// MARK: setupView
private extension PaymentViewController {
    private func setupView() {
        view.backgroundColor = .AppColors.white
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor.AppColors.black
        ]
        navigationController?.navigationBar.tintColor = .AppColors.black
        navigationItem.title = L10n.Payment.title
        navigationItem.backButtonDisplayMode = .minimal
        guard let navigationBar = navigationController?.navigationBar else { return }
        let navBarFrameInView = view.convert(navigationBar.frame, from: navigationBar.superview)
        let navBarMaxY = navBarFrameInView.maxY
        
        view.addSubview(currenciesCollectionView)
        view.addSubview(bottomBackgroundView)
        view.addSubview(payButton)
        view.addSubview(userAgreementLabel)
        view.addSubview(userAgreementButton)
    
        NSLayoutConstraint.activate([
            currenciesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarMaxY + 20),
            currenciesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currenciesCollectionView.widthAnchor.constraint(equalToConstant: 343),
            currenciesCollectionView.heightAnchor.constraint(equalToConstant: 205)
        ])
        NSLayoutConstraint.activate([
            bottomBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackgroundView.heightAnchor.constraint(equalToConstant: 186)
        ])
        NSLayoutConstraint.activate([
            payButton.widthAnchor.constraint(equalToConstant: 343),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        NSLayoutConstraint.activate([
            userAgreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementLabel.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 16),
            userAgreementLabel.widthAnchor.constraint(equalToConstant: 380),
            userAgreementLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        NSLayoutConstraint.activate([
            userAgreementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementButton.topAnchor.constraint(equalTo: userAgreementLabel.bottomAnchor),
            userAgreementButton.widthAnchor.constraint(equalToConstant: 202),
            userAgreementButton.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}

// MARK: дополнительная настройка цвета текста в navigationBar при смене темы (просто установить navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.AppColors.black] ) - недостаточно
extension PaymentViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .light {
            navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor(hexString: "#1A1B22")
            ]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor.white
            ]
        }
    }
}

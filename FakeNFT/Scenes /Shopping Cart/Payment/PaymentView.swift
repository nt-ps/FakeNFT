//
//  PaymentView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import UIKit

protocol PaymentViewProtocol: AnyObject {
    func reloadCurrenciesCollectionView(currencies: [Currency])
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
        paymentPresenter?.loadCurrenciesFromServer()
        ProgressHUDProvider.showProgressHUD()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let snapshot = NSDiffableDataSourceSnapshot<Int, Currency>()
        currenciesCollectionViewDiffableDataSource.apply(snapshot, animatingDifferences: true)
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
    
    // MARK: UI Actions
    @objc private func userAgreementButtonTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse") else { return }
        let request = URLRequest(url: url)
        let webViewController = WebViewAssembly().build(with: request)
        navigationController?.pushViewController(webViewController, animated: true)
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

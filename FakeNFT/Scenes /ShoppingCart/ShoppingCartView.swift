//
//  ShoppingCartView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit



protocol ShoppingCartViewProtocol: AnyObject {
    
}



final class ShoppingCartViewControllerImplementation: UIViewController, ShoppingCartViewProtocol {
    // MARK: Presenter
    weak var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    
    // MARK: UI Elements
    private let filterButton = UIButton()
    private let NFTTableView = UITableView()
    private let goToPaymentButtonBackgroundView = UIView()
    private let NFTsCounterLabel = UILabel()
    private let NFTsTotalPriceLabel = UILabel()
    private let goToPaymentButton = UIButton()
    
    // MARK: Overrides methods
    override func viewDidLoad() {
        setupView()
        NFTTableView.dataSource = self
        NFTTableView.delegate = self
    }
    
    
    // MARK: UI Actions
    @objc private func filterButtonTapped() {
        
    }
    
    @objc private func goToPaymentButtonTapped() {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}


// MARK: Table view data source
extension ShoppingCartViewControllerImplementation: UITableViewDataSource {
    // почитать про diffableDataSourcе
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = NFTTableView.dequeueReusableCell(withIdentifier: "NFTTableViewCell", for: indexPath) as? NFTTableViewCell else { return UITableViewCell() }
        return cell
    }
}


// MARK: Table view delegate
extension ShoppingCartViewControllerImplementation: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 140 }
}


// MARK: view setup
private extension ShoppingCartViewControllerImplementation {
    private func setupView() {
        setUpFilterButton()
        setUpGoToPaymentButtonBackgroundView()
        setUpNFTTableView()
        setUpNFTsCounterLabel()
        setUpGoToPaymentButton()
        setUpNFTsTotalPriceLabel()
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(hexString: "#1A1B22")
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func setUpFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
        filterButton.setImage(.Icons.sort, for: .normal)
        if traitCollection.userInterfaceStyle == .dark {
            filterButton.tintColor = .white
        }
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    private func setUpNFTTableView() {
        NFTTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NFTTableView)
        NSLayoutConstraint.activate([
            NFTTableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 9),
            NFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            NFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            NFTTableView.bottomAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.topAnchor)
        ])
        NFTTableView.backgroundColor = .clear
        NFTTableView.separatorStyle = .none
        NFTTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTTableViewCell")
    }
    
    private func setUpGoToPaymentButtonBackgroundView() {
        goToPaymentButtonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToPaymentButtonBackgroundView)
        NSLayoutConstraint.activate([
            goToPaymentButtonBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            goToPaymentButtonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goToPaymentButtonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goToPaymentButtonBackgroundView.heightAnchor.constraint(equalToConstant: 76)
        ])
        if traitCollection.userInterfaceStyle == .dark {
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
        } else {
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
        }
        goToPaymentButtonBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        goToPaymentButtonBackgroundView.layer.masksToBounds = true
        goToPaymentButtonBackgroundView.layer.cornerRadius = 12
    }
    
    private func setUpNFTsCounterLabel() {
        NFTsCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NFTsCounterLabel)
        NSLayoutConstraint.activate([
            NFTsCounterLabel.topAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.topAnchor, constant: 16),
            NFTsCounterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NFTsCounterLabel.font = .systemFont(ofSize: 15, weight: .regular)
        if traitCollection.userInterfaceStyle == .dark {
            NFTsCounterLabel.textColor = .white
        } else {
            NFTsCounterLabel.textColor = UIColor(hexString: "#1A1B22")
        }
        NFTsCounterLabel.text = "N NFT"
    }
    
    private func setUpNFTsTotalPriceLabel() {
        NFTsTotalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NFTsTotalPriceLabel)
        NSLayoutConstraint.activate([
            NFTsTotalPriceLabel.bottomAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.bottomAnchor, constant: -16),
            NFTsTotalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NFTsTotalPriceLabel.textColor = UIColor(hexString: "#1C9F00")
        NFTsTotalPriceLabel.text = "Total price"
        NFTsTotalPriceLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    private func setUpGoToPaymentButton() {
        goToPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToPaymentButton)
        NSLayoutConstraint.activate([
            goToPaymentButton.centerYAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.centerYAnchor),
            goToPaymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goToPaymentButton.widthAnchor.constraint(equalToConstant: 240),
            goToPaymentButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        goToPaymentButton.layer.cornerRadius = 16
        goToPaymentButton.layer.masksToBounds = true
        goToPaymentButton.setTitle(L10n.Cart.toPayment, for: .normal)
        goToPaymentButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        if traitCollection.userInterfaceStyle == .dark {
            goToPaymentButton.backgroundColor = .white
            goToPaymentButton.setTitleColor(UIColor(hexString: "#1A1B22"), for: .normal)
        } else {
            goToPaymentButton.backgroundColor = UIColor(hexString: "#1A1B22")
            goToPaymentButton.setTitleColor(.white, for: .normal)
        }
        goToPaymentButton.addTarget(self, action: #selector(goToPaymentButtonTapped), for: .touchUpInside)
    }
}


// MARK: Dark theme implementation
extension ShoppingCartViewControllerImplementation {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(hexString: "#1A1B22")
            filterButton.tintColor = .white
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
            NFTsCounterLabel.textColor = .white
            goToPaymentButton.backgroundColor = .white
            goToPaymentButton.titleLabel?.textColor = UIColor(hexString: "#1A1B22")
        } else {
            view.backgroundColor = .white
            filterButton.tintColor = UIColor(hexString: "#1A1B22")
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
            NFTsCounterLabel.textColor = UIColor(hexString: "#1A1B22")
            goToPaymentButton.backgroundColor = UIColor(hexString: "#1A1B22")
            goToPaymentButton.titleLabel?.textColor = .white
        }
    }
}

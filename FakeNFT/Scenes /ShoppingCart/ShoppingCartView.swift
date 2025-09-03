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
    
    // MARK: Overrides methods
    override func viewDidLoad() {
        setupView()
        NFTTableView.dataSource = self
        NFTTableView.delegate = self
    }
    
    
    // MARK: UI Actions
    @objc private func filterButtonTapped() {
        
    }
}


// MARK: Table view data source
extension ShoppingCartViewControllerImplementation: UITableViewDataSource {
    
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
    }
    
    private func setUpFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
        filterButton.setImage(.Icons.sort, for: .normal)
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
        NFTTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTTableViewCell")
        NFTTableView.backgroundColor = .blue
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
        goToPaymentButtonBackgroundView.backgroundColor = .red
        goToPaymentButtonBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        goToPaymentButtonBackgroundView.layer.masksToBounds = true
        goToPaymentButtonBackgroundView.layer.cornerRadius = 12
    }
}


// MARK: dark theme implementation
private extension ShoppingCartViewControllerImplementation {
    
}



//
//  ShoppingCartView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit

protocol ShoppingCartViewProtocol: AnyObject {
    func reloadDataInTableView(nfts: [NFT], totalNFTsPrice: Float, totalNFTsAmount: Int)
}

final class ShoppingCartViewControllerImplementation: UIViewController, ShoppingCartViewProtocol, NFTTableViewCellDelegate {
    // MARK: Presenter
    var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    
    // MARK: UI Elements
    private let filterButton = UIButton()
    private let NFTTableView = UITableView()
    private let goToPaymentButtonBackgroundView = UIView()
    private let NFTsCounterLabel = UILabel()
    private let NFTsTotalPriceLabel = UILabel()
    private let goToPaymentButton = UIButton()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let NFTToDeleteImageView = UIImageView()
    private let labelWhenDeletingNFT = UILabel()
    private let deleteNFTFromCartButton = UIButton()
    private let goBackFromDeletingNFTButton = UIButton()
    
    private var diffableDataSource: UITableViewDiffableDataSource<Int, NFT>?
    
    // MARK: Overrides methods
    override func viewDidLoad() {
        setupView()
        NFTTableView.delegate = self
        diffableDataSource = UITableViewDiffableDataSource(tableView: NFTTableView) { [weak self]
            tableView, indexPath, identifier in
            guard let self,
                  let cell = self.NFTTableView.dequeueReusableCell(withIdentifier: "NFTTableViewCell", for: indexPath) as? NFTTableViewCell,
                  let nfts = shoppingCartPresenter?.getNFTs()
            else { return UITableViewCell() }
            cell.configure(nft: nfts[indexPath.row])
            cell.delegate = self
            return cell
        }
        NFTTableView.dataSource = diffableDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUDProvider.showProgressHUD()
        shoppingCartPresenter?.getOrder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let snapshot = NSDiffableDataSourceSnapshot<Int, NFT>()
        shoppingCartPresenter?.clearNftsInCart()
        diffableDataSource?.apply(snapshot)
    }
    
    func reloadDataInTableView(nfts: [NFT], totalNFTsPrice: Float, totalNFTsAmount: Int) {
        DispatchQueue.main.async {
            self.NFTsCounterLabel.text = "\(totalNFTsAmount) NFT"
            self.NFTsTotalPriceLabel.text = "\(totalNFTsPrice) ETH"
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, NFT>()
        snapshot.appendSections([0])
        snapshot.appendItems(nfts)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
        ProgressHUDProvider.dismissProgressHUD()
    }
    
    // MARK: NFTTableViewCellDelegate method
    func deleteFromCartButtonTapped(for cell: NFTTableViewCell, image: UIImage) {
        blurView.isHidden = false
        NFTToDeleteImageView.isHidden = false
        NFTToDeleteImageView.image = image
        labelWhenDeletingNFT.isHidden = false
        deleteNFTFromCartButton.isHidden = false
        goBackFromDeletingNFTButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1
            self.NFTToDeleteImageView.alpha = 1
            self.labelWhenDeletingNFT.alpha = 1
            self.deleteNFTFromCartButton.alpha = 1
            self.goBackFromDeletingNFTButton.alpha = 1
        }
    }
    
    // MARK: UI Actions
    @objc private func filterButtonTapped() {
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        present(vc, animated: true)
    }
    
    @objc private func goToPaymentButtonTapped() {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
    @objc private func goBackFromDeletingNFTButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 0
            self.NFTToDeleteImageView.alpha = 0
            self.labelWhenDeletingNFT.alpha = 0
            self.deleteNFTFromCartButton.alpha = 0
            self.goBackFromDeletingNFTButton.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.blurView.isHidden = true
            self.NFTToDeleteImageView.isHidden = true
            self.labelWhenDeletingNFT.isHidden = true
            self.deleteNFTFromCartButton.isHidden = true
            self.goBackFromDeletingNFTButton.isHidden = true
        }
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
        setUpBlurView()
        setUpNFTToDeleteImageView()
        setUpLabelWhenDeletingNFT()
        setUpDeleteNFTFromCartButton()
        setUpGoBackFromDeletingNFTButton()
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
        NFTTableView.allowsSelection = false
        NFTTableView.allowsMultipleSelection = false
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
    }
    
    private func setUpNFTsTotalPriceLabel() {
        NFTsTotalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NFTsTotalPriceLabel)
        NSLayoutConstraint.activate([
            NFTsTotalPriceLabel.bottomAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.bottomAnchor, constant: -16),
            NFTsTotalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NFTsTotalPriceLabel.textColor = UIColor(hexString: "#1C9F00")
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
    
    private func setUpBlurView() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        blurView.isHidden = true
        blurView.alpha = 0
    }
    
    private func setUpNFTToDeleteImageView() {
        NFTToDeleteImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NFTToDeleteImageView)
        NSLayoutConstraint.activate([
            NFTToDeleteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NFTToDeleteImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            NFTToDeleteImageView.widthAnchor.constraint(equalToConstant: 108),
            NFTToDeleteImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
        NFTToDeleteImageView.layer.masksToBounds = true
        NFTToDeleteImageView.layer.cornerRadius = 12
        NFTToDeleteImageView.isHidden = true
        NFTToDeleteImageView.alpha = 0
    }
    
    private func setUpLabelWhenDeletingNFT() {
        labelWhenDeletingNFT.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelWhenDeletingNFT)
        NSLayoutConstraint.activate([
            labelWhenDeletingNFT.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelWhenDeletingNFT.topAnchor.constraint(equalTo: NFTToDeleteImageView.bottomAnchor, constant: 12),
            labelWhenDeletingNFT.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        labelWhenDeletingNFT.font = .systemFont(ofSize: 13, weight: .regular)
        labelWhenDeletingNFT.text = L10n.Cart.DeleteAlert.message
        labelWhenDeletingNFT.numberOfLines = 2
        labelWhenDeletingNFT.textAlignment = .center
        if traitCollection.userInterfaceStyle == .dark {
            labelWhenDeletingNFT.textColor = .white
        } else {
            labelWhenDeletingNFT.textColor = UIColor(hexString: "#1A1B22")
        }
        labelWhenDeletingNFT.isHidden = true
        labelWhenDeletingNFT.alpha = 0
    }
    
    private func setUpDeleteNFTFromCartButton() {
        deleteNFTFromCartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteNFTFromCartButton)
        NSLayoutConstraint.activate([
            deleteNFTFromCartButton.topAnchor.constraint(equalTo: labelWhenDeletingNFT.bottomAnchor, constant: 20),
            deleteNFTFromCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            deleteNFTFromCartButton.widthAnchor.constraint(equalToConstant: 127),
            deleteNFTFromCartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        deleteNFTFromCartButton.setTitle(L10n.Cart.DeleteAlert.delete, for: .normal)
        deleteNFTFromCartButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        deleteNFTFromCartButton.setTitleColor(UIColor(hexString: "#F56B6C"), for: .normal)
        deleteNFTFromCartButton.layer.masksToBounds = true
        deleteNFTFromCartButton.layer.cornerRadius = 12
        if traitCollection.userInterfaceStyle == .dark {
            deleteNFTFromCartButton.backgroundColor = .white
        } else {
            deleteNFTFromCartButton.backgroundColor = UIColor(hexString: "#1A1B22")
        }
        deleteNFTFromCartButton.isHidden = true
        deleteNFTFromCartButton.alpha = 0
    }
    
    private func setUpGoBackFromDeletingNFTButton() {
        goBackFromDeletingNFTButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goBackFromDeletingNFTButton)
        NSLayoutConstraint.activate([
            goBackFromDeletingNFTButton.topAnchor.constraint(equalTo: labelWhenDeletingNFT.bottomAnchor, constant: 20),
            goBackFromDeletingNFTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            goBackFromDeletingNFTButton.widthAnchor.constraint(equalToConstant: 127),
            goBackFromDeletingNFTButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        goBackFromDeletingNFTButton.setTitle(L10n.Cart.DeleteAlert.cancel, for: .normal)
        goBackFromDeletingNFTButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        goBackFromDeletingNFTButton.layer.masksToBounds = true
        goBackFromDeletingNFTButton.layer.cornerRadius = 12
        if traitCollection.userInterfaceStyle == .dark {
            goBackFromDeletingNFTButton.backgroundColor = .white
            goBackFromDeletingNFTButton.setTitleColor(UIColor(hexString: "#1A1B22"), for: .normal)
        } else {
            goBackFromDeletingNFTButton.backgroundColor = UIColor(hexString: "#1A1B22")
            goBackFromDeletingNFTButton.setTitleColor(.white, for: .normal)
        }
        goBackFromDeletingNFTButton.isHidden = true
        goBackFromDeletingNFTButton.alpha = 0
        goBackFromDeletingNFTButton.addTarget(self, action: #selector(goBackFromDeletingNFTButtonTapped), for: .touchUpInside)
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
            goToPaymentButton.setTitleColor(UIColor(hexString: "#1A1B22"), for: .normal)
            labelWhenDeletingNFT.textColor = .white
            deleteNFTFromCartButton.backgroundColor = .white
            goBackFromDeletingNFTButton.backgroundColor = .white
            goBackFromDeletingNFTButton.setTitleColor(UIColor(hexString: "#1A1B22"), for: .normal)
        } else {
            view.backgroundColor = .white
            filterButton.tintColor = UIColor(hexString: "#1A1B22")
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
            NFTsCounterLabel.textColor = UIColor(hexString: "#1A1B22")
            goToPaymentButton.backgroundColor = UIColor(hexString: "#1A1B22")
            goToPaymentButton.setTitleColor(.white, for: .normal)
            labelWhenDeletingNFT.textColor = UIColor(hexString: "#1A1B22")
            deleteNFTFromCartButton.backgroundColor = UIColor(hexString: "#1A1B22")
            goBackFromDeletingNFTButton.backgroundColor = UIColor(hexString: "#1A1B22")
            goBackFromDeletingNFTButton.setTitleColor(.white, for: .normal)
        }
    }
}

//
//  ShoppingCartView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit

protocol ShoppingCartViewProtocol: AnyObject {
    func reloadDataInTableView(nfts: [NFT], totalNFTsPrice: Float, totalNFTsAmount: Int)
    func showPlaceholderIf(needed: Bool)
}

final class ShoppingCartViewControllerImplementation: UIViewController, ShoppingCartViewProtocol, NFTTableViewCellDelegate {
    // MARK: Presenter
    var shoppingCartPresenter: ShoppingCartPresenterProtocol?
    
    // MARK: UI Elements
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setImage(.Icons.sort, for: .normal)
        if traitCollection.userInterfaceStyle == .dark {
            filterButton.tintColor = .white
        } else {
            filterButton.tintColor = UIColor(hexString: "#1A1B22")
        }
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.isHidden = true
        return filterButton
    }()
    private lazy var NFTTableView: UITableView = {
        let NFTTableView = UITableView()
        NFTTableView.translatesAutoresizingMaskIntoConstraints = false
        NFTTableView.backgroundColor = .clear
        NFTTableView.separatorStyle = .none
        NFTTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTTableViewCell")
        NFTTableView.allowsSelection = false
        NFTTableView.allowsMultipleSelection = false
        return NFTTableView
    }()
    private lazy var goToPaymentButtonBackgroundView: UIView = {
        let goToPaymentButtonBackgroundView = UIView()
        goToPaymentButtonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        if traitCollection.userInterfaceStyle == .dark {
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
        } else {
            goToPaymentButtonBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
        }
        goToPaymentButtonBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        goToPaymentButtonBackgroundView.layer.masksToBounds = true
        goToPaymentButtonBackgroundView.layer.cornerRadius = 12
        goToPaymentButtonBackgroundView.isHidden = true
        return goToPaymentButtonBackgroundView
    }()
    private lazy var NFTsCounterLabel: UILabel = {
        let NFTsCounterLabel = UILabel()
        NFTsCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        NFTsCounterLabel.font = .systemFont(ofSize: 15, weight: .regular)
        if traitCollection.userInterfaceStyle == .dark {
            NFTsCounterLabel.textColor = .white
        } else {
            NFTsCounterLabel.textColor = UIColor(hexString: "#1A1B22")
        }
        NFTsCounterLabel.isHidden = true
        return NFTsCounterLabel
    }()
    private lazy var NFTsTotalPriceLabel: UILabel = {
        let NFTsTotalPriceLabel = UILabel()
        NFTsTotalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NFTsTotalPriceLabel.textColor = UIColor(hexString: "#1C9F00")
        NFTsTotalPriceLabel.font = .systemFont(ofSize: 17, weight: .bold)
        NFTsTotalPriceLabel.isHidden = true
        return NFTsTotalPriceLabel
    }()
    private lazy var goToPaymentButton: UIButton = {
        let goToPaymentButton = UIButton()
        goToPaymentButton.translatesAutoresizingMaskIntoConstraints = false
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
        goToPaymentButton.isHidden = true
        return goToPaymentButton
    }()
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isHidden = true
        blurView.alpha = 0
        return blurView
    }()
    private lazy var NFTToDeleteImageView: UIImageView = {
        let NFTToDeleteImageView = UIImageView()
        NFTToDeleteImageView.translatesAutoresizingMaskIntoConstraints = false
        NFTToDeleteImageView.layer.masksToBounds = true
        NFTToDeleteImageView.layer.cornerRadius = 12
        NFTToDeleteImageView.isHidden = true
        NFTToDeleteImageView.alpha = 0
        return NFTToDeleteImageView
    }()
    private lazy var labelWhenDeletingNFT: UILabel = {
        let labelWhenDeletingNFT = UILabel()
        labelWhenDeletingNFT.translatesAutoresizingMaskIntoConstraints = false
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
        return labelWhenDeletingNFT
    }()
    private lazy var deleteNFTFromCartButton: UIButton = {
        let deleteNFTFromCartButton = UIButton()
        deleteNFTFromCartButton.translatesAutoresizingMaskIntoConstraints = false
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
        deleteNFTFromCartButton.addTarget(self, action: #selector(deleteNFTFromCartButtonTapped), for: .touchUpInside)
        return deleteNFTFromCartButton
    }()
    private lazy var goBackFromDeletingNFTButton: UIButton = {
        let goBackFromDeletingNFTButton = UIButton()
        goBackFromDeletingNFTButton.translatesAutoresizingMaskIntoConstraints = false
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
        return goBackFromDeletingNFTButton
    }()
    private lazy var emptyCartLabel: UILabel = {
        let emptyCartLabel = UILabel()
        emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyCartLabel.font = .systemFont(ofSize: 17, weight: .bold)
        emptyCartLabel.numberOfLines = 1
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.text = L10n.Cart.empty
        if traitCollection.userInterfaceStyle == .dark {
            emptyCartLabel.textColor = .white
        } else {
            emptyCartLabel.textColor = UIColor(hexString: "#1A1B22")
        }
        emptyCartLabel.isHidden = true
        return emptyCartLabel
    }()
    
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
        #warning("проверить работает ли без этойс троки на симуляторе")
        //NFTTableView.dataSource = diffableDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUDProvider.showProgressHUD()
        shoppingCartPresenter?.getOrder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    func showPlaceholderIf(needed: Bool) {
        ProgressHUDProvider.dismissProgressHUD()
        DispatchQueue.main.async {
            self.emptyCartLabel.isHidden = !needed
            self.NFTsCounterLabel.isHidden = needed
            self.NFTsTotalPriceLabel.isHidden = needed
            self.goToPaymentButtonBackgroundView.isHidden = needed
            self.goToPaymentButton.isHidden = needed
            self.filterButton.isHidden = needed
        }
    }
    
    // MARK: NFTTableViewCellDelegate method
    func deleteFromCartButtonTapped(NFTsToDeleteName: String, image: UIImage) {
        hideOrShowNFTDeletingAlert(needToHide: false)
        shoppingCartPresenter?.NFTsToDeleteName = NFTsToDeleteName
    }
    
    private func hideOrShowNFTDeletingAlert(needToHide: Bool) {
        let neededAlphaValue = needToHide ? CGFloat(0) : CGFloat(1)
        let timeToWait = needToHide ? TimeInterval(0.3) : TimeInterval(0)
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = neededAlphaValue
            self.NFTToDeleteImageView.alpha = neededAlphaValue
            self.labelWhenDeletingNFT.alpha = neededAlphaValue
            self.deleteNFTFromCartButton.alpha = neededAlphaValue
            self.goBackFromDeletingNFTButton.alpha = neededAlphaValue
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWait) {
            self.blurView.isHidden = needToHide
            self.NFTToDeleteImageView.isHidden = needToHide
            self.labelWhenDeletingNFT.isHidden = needToHide
            self.deleteNFTFromCartButton.isHidden = needToHide
            self.goBackFromDeletingNFTButton.isHidden = needToHide
        }
    }
    
    // MARK: UI Actions
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: L10n.SortAlert.title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: L10n.SortAlert.byPrice, style: .default) { [weak self] _ in
            let snapshot = NSDiffableDataSourceSnapshot<Int, NFT>()
            self?.diffableDataSource?.apply(snapshot)
            self?.shoppingCartPresenter?.sortOrderBy(L10n.SortAlert.byPrice)
        })
        alert.addAction(UIAlertAction(title: L10n.SortAlert.byRating, style: .default,) { [weak self] _ in
            let snapshot = NSDiffableDataSourceSnapshot<Int, NFT>()
            self?.diffableDataSource?.apply(snapshot)
            self?.shoppingCartPresenter?.sortOrderBy(L10n.SortAlert.byRating)
        })
        alert.addAction(UIAlertAction(title: L10n.SortAlert.byName, style: .default,) { [weak self] _ in
            let snapshot = NSDiffableDataSourceSnapshot<Int, NFT>()
            self?.diffableDataSource?.apply(snapshot)
            self?.shoppingCartPresenter?.sortOrderBy(L10n.SortAlert.byName)
        })
        alert.addAction(UIAlertAction(title: L10n.SortAlert.close, style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func goToPaymentButtonTapped() {
        guard let paymentView = shoppingCartPresenter?.preparePaymentView() else { return }
        navigationController?.pushViewController(paymentView, animated: true)
    }
    
    @objc private func goBackFromDeletingNFTButtonTapped() {
        hideOrShowNFTDeletingAlert(needToHide: true)
    }
    
    @objc private func deleteNFTFromCartButtonTapped() {
        hideOrShowNFTDeletingAlert(needToHide: true)
        shoppingCartPresenter?.deleteNFTFromCart()
    }
}

// MARK: Table view delegate
extension ShoppingCartViewControllerImplementation: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 140 }
}

// MARK: view setup
private extension ShoppingCartViewControllerImplementation {
    private func setupView() {
        view.addSubview(filterButton)
        view.addSubview(NFTTableView)
        view.addSubview(goToPaymentButtonBackgroundView)
        view.addSubview(NFTsCounterLabel)
        view.addSubview(NFTsTotalPriceLabel)
        view.addSubview(goToPaymentButton)
        view.addSubview(blurView)
        view.addSubview(NFTToDeleteImageView)
        view.addSubview(labelWhenDeletingNFT)
        view.addSubview(deleteNFTFromCartButton)
        view.addSubview(goBackFromDeletingNFTButton)
        view.addSubview(emptyCartLabel)
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
        NSLayoutConstraint.activate([
            NFTTableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 9),
            NFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            NFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            NFTTableView.bottomAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            goToPaymentButtonBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            goToPaymentButtonBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goToPaymentButtonBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goToPaymentButtonBackgroundView.heightAnchor.constraint(equalToConstant: 76)
        ])
        NSLayoutConstraint.activate([
            NFTsCounterLabel.topAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.topAnchor, constant: 16),
            NFTsCounterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            NFTsTotalPriceLabel.bottomAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.bottomAnchor, constant: -16),
            NFTsTotalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            goToPaymentButton.centerYAnchor.constraint(equalTo: goToPaymentButtonBackgroundView.centerYAnchor),
            goToPaymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goToPaymentButton.widthAnchor.constraint(equalToConstant: 240),
            goToPaymentButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            NFTToDeleteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NFTToDeleteImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            NFTToDeleteImageView.widthAnchor.constraint(equalToConstant: 108),
            NFTToDeleteImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
        NSLayoutConstraint.activate([
            labelWhenDeletingNFT.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelWhenDeletingNFT.topAnchor.constraint(equalTo: NFTToDeleteImageView.bottomAnchor, constant: 12),
            labelWhenDeletingNFT.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            deleteNFTFromCartButton.topAnchor.constraint(equalTo: labelWhenDeletingNFT.bottomAnchor, constant: 20),
            deleteNFTFromCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            deleteNFTFromCartButton.widthAnchor.constraint(equalToConstant: 127),
            deleteNFTFromCartButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            goBackFromDeletingNFTButton.topAnchor.constraint(equalTo: labelWhenDeletingNFT.bottomAnchor, constant: 20),
            goBackFromDeletingNFTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            goBackFromDeletingNFTButton.widthAnchor.constraint(equalToConstant: 127),
            goBackFromDeletingNFTButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCartLabel.widthAnchor.constraint(equalToConstant: 300),
            emptyCartLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        navigationItem.backButtonDisplayMode = .minimal
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = UIColor(hexString: "#1A1B22")
        } else {
            view.backgroundColor = .white
        }
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
            emptyCartLabel.textColor = .white
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
            emptyCartLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
}

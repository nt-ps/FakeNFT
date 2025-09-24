//
//  ShoppingCartView.swift
//  FakeNFT
//
//  Created by oneche$$$ on 01.09.2025.
//

import UIKit

protocol ShoppingCartViewProtocol: AnyObject {
    func reloadDataInTableView(nfts: [Nft], totalNFTsPrice: Float, totalNFTsAmount: Int)
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
        filterButton.tintColor = .AppColors.black
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
        goToPaymentButtonBackgroundView.backgroundColor = .AppColors.lightGray
        goToPaymentButtonBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        goToPaymentButtonBackgroundView.layer.masksToBounds = true
        goToPaymentButtonBackgroundView.layer.cornerRadius = 12
        goToPaymentButtonBackgroundView.isHidden = true
        return goToPaymentButtonBackgroundView
    }()
    private lazy var NFTsCounterLabel: UILabel = {
        let NFTsCounterLabel = UILabel()
        NFTsCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        NFTsCounterLabel.font = .caption1
        NFTsCounterLabel.textColor = .AppColors.black
        NFTsCounterLabel.isHidden = true
        return NFTsCounterLabel
    }()
    private lazy var NFTsTotalPriceLabel: UILabel = {
        let NFTsTotalPriceLabel = UILabel()
        NFTsTotalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NFTsTotalPriceLabel.textColor = UIColor(hexString: "#1C9F00")
        NFTsTotalPriceLabel.font = .bodyBold
        NFTsTotalPriceLabel.isHidden = true
        return NFTsTotalPriceLabel
    }()
    private lazy var goToPaymentButton: UIButton = {
        let goToPaymentButton = UIButton()
        goToPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        goToPaymentButton.layer.cornerRadius = 16
        goToPaymentButton.layer.masksToBounds = true
        goToPaymentButton.setTitle(L10n.Cart.toPayment, for: .normal)
        goToPaymentButton.titleLabel?.font = .bodyBold
        goToPaymentButton.backgroundColor = .AppColors.black
        goToPaymentButton.setTitleColor(.AppColors.white, for: .normal)
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
        labelWhenDeletingNFT.font = .caption2
        labelWhenDeletingNFT.text = L10n.Cart.DeleteAlert.message
        labelWhenDeletingNFT.numberOfLines = 2
        labelWhenDeletingNFT.textAlignment = .center
        labelWhenDeletingNFT.textColor = .AppColors.black
        labelWhenDeletingNFT.isHidden = true
        labelWhenDeletingNFT.alpha = 0
        return labelWhenDeletingNFT
    }()
    private lazy var deleteNFTFromCartButton: UIButton = {
        let deleteNFTFromCartButton = UIButton()
        deleteNFTFromCartButton.translatesAutoresizingMaskIntoConstraints = false
        deleteNFTFromCartButton.setTitle(L10n.Cart.DeleteAlert.delete, for: .normal)
        deleteNFTFromCartButton.titleLabel?.font = .bodyRegular
        deleteNFTFromCartButton.setTitleColor(UIColor(hexString: "#F56B6C"), for: .normal)
        deleteNFTFromCartButton.backgroundColor = .AppColors.black
        deleteNFTFromCartButton.layer.masksToBounds = true
        deleteNFTFromCartButton.layer.cornerRadius = 12
        deleteNFTFromCartButton.isHidden = true
        deleteNFTFromCartButton.alpha = 0
        deleteNFTFromCartButton.addTarget(self, action: #selector(deleteNFTFromCartButtonTapped), for: .touchUpInside)
        return deleteNFTFromCartButton
    }()
    private lazy var goBackFromDeletingNFTButton: UIButton = {
        let goBackFromDeletingNFTButton = UIButton()
        goBackFromDeletingNFTButton.translatesAutoresizingMaskIntoConstraints = false
        goBackFromDeletingNFTButton.setTitle(L10n.Cart.DeleteAlert.cancel, for: .normal)
        goBackFromDeletingNFTButton.titleLabel?.font = .bodyRegular
        goBackFromDeletingNFTButton.layer.masksToBounds = true
        goBackFromDeletingNFTButton.layer.cornerRadius = 12
        goBackFromDeletingNFTButton.backgroundColor = .AppColors.black
        goBackFromDeletingNFTButton.setTitleColor(.AppColors.white, for: .normal)
        goBackFromDeletingNFTButton.isHidden = true
        goBackFromDeletingNFTButton.alpha = 0
        goBackFromDeletingNFTButton.addTarget(self, action: #selector(goBackFromDeletingNFTButtonTapped), for: .touchUpInside)
        return goBackFromDeletingNFTButton
    }()
    private lazy var emptyCartLabel: UILabel = {
        let emptyCartLabel = UILabel()
        emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyCartLabel.font = .bodyBold
        emptyCartLabel.numberOfLines = 1
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.text = L10n.Cart.empty
        emptyCartLabel.textColor = .AppColors.black
        emptyCartLabel.isHidden = true
        return emptyCartLabel
    }()
    
    private var diffableDataSource: UITableViewDiffableDataSource<Int, Nft>?
    
    // MARK: Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NFTTableView.delegate = self
        diffableDataSource = UITableViewDiffableDataSource(tableView: NFTTableView) { [weak self]
            tableView, indexPath, nft in
            guard
                let self,
                let cell = self.NFTTableView.dequeueReusableCell(withIdentifier: "NFTTableViewCell", for: indexPath) as? NFTTableViewCell
            else { return UITableViewCell() }
            cell.configure(nft: nft)
            cell.delegate = self
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        ProgressHUDProvider.showProgressHUD()
        shoppingCartPresenter?.getOrder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let snapshot = NSDiffableDataSourceSnapshot<Int, Nft>()
        shoppingCartPresenter?.clearNftsInCart()
        diffableDataSource?.apply(snapshot)
    }
    
    func reloadDataInTableView(nfts: [Nft], totalNFTsPrice: Float, totalNFTsAmount: Int) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Nft>()
        snapshot.appendSections([0])
        snapshot.appendItems(nfts)
        DispatchQueue.main.async {
            self.NFTsCounterLabel.text = "\(totalNFTsAmount) NFT"
            self.NFTsTotalPriceLabel.text = "\(totalNFTsPrice) ETH"
            self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
        }
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
            let snapshot = NSDiffableDataSourceSnapshot<Int, Nft>()
            self?.diffableDataSource?.apply(snapshot)
            self?.shoppingCartPresenter?.sortOrderBy(L10n.SortAlert.byPrice)
        })
        alert.addAction(UIAlertAction(title: L10n.SortAlert.byRating, style: .default) { [weak self] _ in
            let snapshot = NSDiffableDataSourceSnapshot<Int, Nft>()
            self?.diffableDataSource?.apply(snapshot)
            self?.shoppingCartPresenter?.sortOrderBy(L10n.SortAlert.byRating)
        })
        alert.addAction(UIAlertAction(title: L10n.SortAlert.byName, style: .default) { [weak self] _ in
            let snapshot = NSDiffableDataSourceSnapshot<Int, Nft>()
            self?.diffableDataSource?.apply(snapshot)
            self?.shoppingCartPresenter?.sortOrderBy(L10n.SortAlert.byName)
        })
        alert.addAction(UIAlertAction(title: L10n.SortAlert.close, style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func goToPaymentButtonTapped() {
        guard let paymentView = shoppingCartPresenter?.preparePaymentView() else { return }
        navigationItem.backButtonDisplayMode = .minimal
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
        view.backgroundColor = .AppColors.white
        
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
    }
}

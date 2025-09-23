//
//  FavouriteNFTViewController.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

protocol FavouriteNFTViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showNFTs(_ nfts: [Nft])
    func showError(_ message: String)
    func showEmptyState()
}

final class FavouriteNFTViewController: UIViewController, ViewControllerDelegate {

    // MARK: Properties
    private enum CollectionViewConstants {
        static let itemSize = CGSize(width: 168, height: 80)
        static let interitemSpacing: CGFloat = 7
        static let sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        static let lineSpacing: CGFloat = 20
    }
    
    private let favouriteNFTView = FavouriteNFTView()
    private var presenter: FavouriteNFTPresenterProtocol?

    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    init(presenter: FavouriteNFTPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setPresenter(_ presenter: FavouriteNFTPresenterProtocol) {
        self.presenter = presenter
    }

    override func loadView() {
        view = favouriteNFTView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        favouriteNFTView.collectionView.dataSource = self
        favouriteNFTView.collectionView.delegate = self
        presenter?.viewDidLoad()
    }
    
    // MARK: Setup
    private func setupView() {
        let backButton = NavigationBackButton()
        backButton.target = self
        backButton.action = #selector(cancelTapped)
        navigationItem.leftBarButtonItem = backButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .AppColors.white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        navigationItem.title = L10n.FavouriteNFT.title
    }

    // MARK: Actions
    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavouriteNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let presenter = presenter as? FavouriteNFTPresenter {
            return presenter.getNFTCount()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavouriteNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        if let presenter = presenter as? FavouriteNFTPresenter,
           let nft = presenter.getNFT(at: indexPath.row) {
            cell.configCell(model: nft)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavouriteNFTViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CollectionViewConstants.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        CollectionViewConstants.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CollectionViewConstants.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        CollectionViewConstants.sectionInset
    }
}

// MARK: - FavouriteNFTViewProtocol
extension FavouriteNFTViewController: FavouriteNFTViewProtocol {
    
    func showLoading() {
        favouriteNFTView.changeState(.loading)
    }
    
    func hideLoading() {
        favouriteNFTView.collectionView.reloadData()
    }
    
    func showNFTs(_ nfts: [Nft]) {
        favouriteNFTView.changeState(.standard)
        favouriteNFTView.collectionView.reloadData()
    }
    
    func showError(_ message: String) {
        let alertModel = AlertModel.error(message: message)
        AlertPresenter.present(in: self, model: alertModel)
    }
    
    func showEmptyState() {
        favouriteNFTView.changeState(.empty)
        favouriteNFTView.collectionView.reloadData()
    }
}

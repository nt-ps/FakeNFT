//
//  FavouriteNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 21.09.2025.
//

import UIKit

final class FavouriteNFTView: UIView {

    // MARK: Properties
    enum State {
        case loading
        case empty
        case standard
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .AppColors.white
        collectionView.allowsSelection = false
        collectionView.register(FavouriteNFTCollectionViewCell.self)
        return collectionView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .AppColors.black
        label.font = .bodyBold
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicatorView = UIBlockingProgressHUD()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func changeState(_ state: State) {
        switch state {
        case .loading:
            UIBlockingProgressHUD.show()
            emptyLabel.isHidden = true
            collectionView.isHidden = true
        case .empty:
            UIBlockingProgressHUD.dismiss()
            emptyLabel.isHidden = false
            collectionView.isHidden = true
            emptyLabel.text = L10n.FavouriteNFT.empty
        case .standard:
            UIBlockingProgressHUD.dismiss()
            emptyLabel.isHidden = true
            collectionView.isHidden = false
        }
    }

    private func setupUI() {
        backgroundColor = .AppColors.white
        emptyLabel.isHidden = true
    }

    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

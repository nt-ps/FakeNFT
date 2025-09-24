//
//  FavouriteNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 21.09.2025.
//

import UIKit
import Kingfisher

final class FavouriteNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: Properties
    private(set) var nftId: String?
    
    private enum Constants {
        enum ImageView {
            static let size: CGFloat = 80
            static let likeButtonSize: CGFloat = 30
        }
        
        enum InfoStack {
            static let spacing: CGFloat = 8
            static let leadingInset: CGFloat = 12
            static let height: CGFloat = 80
        }
    }
    
    private lazy var nftImageView: NFTImageView = {
        let nftImageView = NFTImageView(likeButtonSize: Constants.ImageView.likeButtonSize)
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        return nftImageView
    }()
    
    private lazy var ratingView: RatingView = {
        let ratingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    private lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = .AppColors.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.InfoStack.spacing
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameLabel: Label = {
        let label = Label()
        label.font = .bodyBold
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: Label = {
        let label = Label()
        label.font = .caption1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func configCell(model: Nft) {
        nftId = model.id
        nameLabel.text = model.name
        priceLabel.text = CurrencyFormatter.shared.string(for: model.price)
        ratingView.setRating(rating: model.rating)
        
        let imageString = model.images.first ?? ""
        nftImageView.setNFTImage(urlString: imageString)
        nftImageView.setNFTId(model.id)
        nftImageView.setLiked(true)
    }

    private func setupUI() {
        backgroundColor = .AppColors.white
        
        contentView.addSubview(content)
        
        [nftImageView, infoStack].forEach {
            content.addSubview($0)
        }

        [nameLabel, ratingView, priceLabel].forEach {
            infoStack.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nftImageView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: content.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.ImageView.size),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.ImageView.size),
            
            infoStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: Constants.InfoStack.leadingInset),
            infoStack.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            infoStack.centerYAnchor.constraint(equalTo: content.centerYAnchor),
            infoStack.heightAnchor.constraint(equalToConstant: Constants.InfoStack.height)
        ])
    }
}

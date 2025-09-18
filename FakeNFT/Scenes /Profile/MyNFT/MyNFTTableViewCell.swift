//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit
import Kingfisher

final class MyNFTTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: Properties
    private enum Constants {
        static let skeletonText = "             "
        
        enum ImageView {
            static let size: CGFloat = 108
        }
        
        enum InfoStack {
            static let width: CGFloat = 100
            static let spacing: CGFloat = 4
            static let inset: CGFloat = 20
            static let height: CGFloat = 62
        }
        
        enum PriceStack {
            static let leadingInset: CGFloat = 137
            static let spacing: CGFloat = 2
            static let width: CGFloat = 100
        }
        
        enum Content {
            static let inset: CGFloat = 16
            static let spacing: CGFloat = 39
        }
    }
    
    private lazy var nftImageView = NFTImageView()
    
    private lazy var ratingView = RatingView()

    private lazy var infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Constants.InfoStack.spacing
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var priceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var nameLabel: Label = {
        let label = Label()
        label.font = .bodyBold
        label.numberOfLines = 2
        return label
    }()

    private lazy var authorLabel: Label = {
        let label = Label()
        label.font = .caption2
        label.textColor = .AppColors.black
        return label
    }()
    
    private lazy var priceTextLabel: Label = {
        let label = Label()
        label.font = .caption2
        label.textAlignment = .left
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label()
        label.font = .bodyBold
        label.textAlignment = .left
        return label
    }()

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func configCell(model: Nft) {
        nameLabel.text = model.name
        authorLabel.text = L10n.MyNFT.from + " " + model.author
        priceLabel.text = CurrencyFormatter.shared.string(for: model.price)
        priceTextLabel.text = L10n.MyNFT.price
        ratingView.setRating(rating: model.rating)
        
        let imageString = model.images.first ?? ""
        nftImageView.setNFTImage(urlString: imageString)
        nftImageView.setNFTId(model.id)
        
        let isLiked = ProfileStorage.shared.profile?.likes.contains(model.id) ?? false
        nftImageView.setLiked(isLiked)
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .AppColors.white
        
        [nftImageView, infoStack, priceStack].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [nameLabel, ratingView, authorLabel].forEach {
            infoStack.addArrangedSubview($0)
        }

        [priceTextLabel, priceLabel].forEach {
            priceStack.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Content.inset),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Content.inset),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Content.inset),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.ImageView.size),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.ImageView.size),

            infoStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: Constants.InfoStack.inset),
            infoStack.widthAnchor.constraint(equalToConstant: Constants.InfoStack.width),
            infoStack.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            
            priceStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: Constants.PriceStack.leadingInset),
            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Content.spacing),
            priceStack.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
        ])
    }
}

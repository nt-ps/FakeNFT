//
//  NFTTableVIewCell.swift
//  FakeNFT
//
//  Created by oneche$$$ on 02.09.2025.
//

import UIKit
import Kingfisher



protocol NFTTableViewCellDelegate: AnyObject {
    func deleteFromCartButtonTapped(NFTsToDeleteName: String, image: UIImage)
}



final class NFTTableViewCell: UITableViewCell {
    weak var delegate: NFTTableViewCellDelegate?
    
    // MARK: UI Elements
    private let NFTNameLabel = UILabel()
    private let ratingImageView = UIImageView()
    private let priceLabel = UILabel()
    private let priceValueLabel = UILabel()
    private let NFTImageView = UIImageView()
    private let deleteFromCartButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nft: NFT) {
        NFTNameLabel.text = nft.name
        switch nft.rating {
        case 0:
            ratingImageView.image = UIImage(resource: .Icons.Rating.zero)
        case 1:
            ratingImageView.image = UIImage(resource: .Icons.Rating.one)
        case 2:
            ratingImageView.image = UIImage(resource: .Icons.Rating.two)
        case 3:
            ratingImageView.image = UIImage(resource: .Icons.Rating.three)
        case 4:
            ratingImageView.image = UIImage(resource: .Icons.Rating.four)
        case 5:
            ratingImageView.image = UIImage(resource: .Icons.Rating.five)
        default:
            break
        }
        priceValueLabel.text = "\(nft.price) ETH"
        if let url = URL(string: nft.images[0]) {
            NFTImageView.kf.setImage(with: url)
        }
    }
    
    // MARK: UI Actions
    @objc private func deleteFromCartButtonTapped() {
        delegate?.deleteFromCartButtonTapped(NFTsToDeleteName: NFTNameLabel.text ?? "", image: NFTImageView.image ?? UIImage())
    }
}


// MARK: setup cell view
private extension NFTTableViewCell {
    private func setupView() {
        setUpNFTImageView()
        setUpNFTNameLabel()
        setUpRatingImageView()
        setUpPriceLabel()
        setUpPriceValueLabel()
        setUpDeleteFromCartButton()
        backgroundColor = .clear
    }
    
    private func setUpNFTNameLabel() {
        NFTNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(NFTNameLabel)
        NSLayoutConstraint.activate([
            NFTNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            NFTNameLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
        ])
        NFTNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        NFTNameLabel.text = "NFTs name"
    }
    
    private func setUpRatingImageView() {
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingImageView)
        NSLayoutConstraint.activate([
            ratingImageView.topAnchor.constraint(equalTo: NFTNameLabel.bottomAnchor, constant: 4),
            ratingImageView.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20)
        ])
        ratingImageView.image = UIImage(resource: .Icons.Rating.three)
    }
    
    private func setUpNFTImageView() {
        NFTImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(NFTImageView)
        NSLayoutConstraint.activate([
            NFTImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            NFTImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            NFTImageView.widthAnchor.constraint(equalToConstant: 108),
            NFTImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
        NFTImageView.layer.cornerRadius = 12
        NFTImageView.layer.masksToBounds = true
    }
    
    private func setUpPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 12)
        ])
        priceLabel.text = L10n.Cart.price
        priceLabel.font = .systemFont(ofSize: 13, weight: .regular)
        if traitCollection.userInterfaceStyle == .dark {
            priceLabel.textColor = .white
        } else {
            priceLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpPriceValueLabel() {
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceValueLabel)
        NSLayoutConstraint.activate([
            priceValueLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceValueLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2)
        ])
        priceValueLabel.text = "N $$$$$"
        if traitCollection.userInterfaceStyle == .dark {
            priceValueLabel.textColor = .white
        } else {
            priceValueLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpDeleteFromCartButton() {
        deleteFromCartButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteFromCartButton)
        NSLayoutConstraint.activate([
            deleteFromCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteFromCartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        deleteFromCartButton.setImage(UIImage(resource: .Icons.Cart.delete), for: .normal)
        if traitCollection.userInterfaceStyle == .dark {
            deleteFromCartButton.tintColor = .white
        } else {
            deleteFromCartButton.tintColor = UIColor(hexString: "#1A1B22")
        }
        deleteFromCartButton.addTarget(self, action: #selector(deleteFromCartButtonTapped), for: .touchUpInside)
    }
}


// MARK: Dark theme implementation
extension NFTTableViewCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .dark {
            NFTNameLabel.textColor = .white
            priceLabel.textColor = .white
            priceValueLabel.textColor = .white
            deleteFromCartButton.tintColor = .white
        } else {
            NFTNameLabel.textColor = UIColor(hexString: "#1A1B22")
            priceLabel.textColor = UIColor(hexString: "#1A1B22")
            priceValueLabel.textColor = UIColor(hexString: "#1A1B22")
            deleteFromCartButton.tintColor = UIColor(hexString: "#1A1B22")
        }
    }
}

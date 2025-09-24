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
    private lazy var NFTNameLabel: UILabel = {
        let NFTNameLabel = UILabel()
        NFTNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NFTNameLabel.font = .bodyBold
        NFTNameLabel.textColor = .AppColors.black
        return NFTNameLabel
    }()
    private lazy var ratingImageView: UIImageView = {
        let ratingImageView = UIImageView()
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingImageView.image = UIImage(resource: .Icons.Rating.three)
        return ratingImageView
    }()
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = L10n.Cart.price
        priceLabel.font = .caption2
        priceLabel.textColor = .AppColors.black
        return priceLabel
    }()
    private lazy var priceValueLabel: UILabel = {
        let priceValueLabel = UILabel()
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        priceValueLabel.textColor = .AppColors.black
        priceValueLabel.font = .bodyBold
        return priceValueLabel
    }()
    private lazy var NFTImageView: UIImageView = {
        let NFTImageView = UIImageView()
        NFTImageView.translatesAutoresizingMaskIntoConstraints = false
        NFTImageView.layer.cornerRadius = 12
        NFTImageView.layer.masksToBounds = true
        return NFTImageView
    }()
    private lazy var deleteFromCartButton: UIButton = {
        let deleteFromCartButton = UIButton()
        deleteFromCartButton.translatesAutoresizingMaskIntoConstraints = false
        deleteFromCartButton.setImage(UIImage(resource: .Icons.Cart.delete), for: .normal)
        deleteFromCartButton.tintColor = .AppColors.black
        deleteFromCartButton.addTarget(self, action: #selector(deleteFromCartButtonTapped), for: .touchUpInside)
        return deleteFromCartButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nft: Nft) {
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
        backgroundColor = .clear
        
        contentView.addSubview(NFTImageView)
        contentView.addSubview(NFTNameLabel)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceValueLabel)
        contentView.addSubview(deleteFromCartButton)
        
        NSLayoutConstraint.activate([
            NFTImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            NFTImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            NFTImageView.widthAnchor.constraint(equalToConstant: 108),
            NFTImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
        NSLayoutConstraint.activate([
            NFTNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            NFTNameLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
        ])
        NSLayoutConstraint.activate([
            ratingImageView.topAnchor.constraint(equalTo: NFTNameLabel.bottomAnchor, constant: 4),
            ratingImageView.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 12)
        ])
        NSLayoutConstraint.activate([
            priceValueLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
            priceValueLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2)
        ])
        NSLayoutConstraint.activate([
            deleteFromCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteFromCartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

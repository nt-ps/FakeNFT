//
//  NFTTableVIewCell.swift
//  FakeNFT
//
//  Created by oneche$$$ on 02.09.2025.
//

import UIKit

final class NFTTableViewCell: UITableViewCell {
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
}


// MARK: setup cell view
private extension NFTTableViewCell {
    private func setupView() {
        setUpNFTImageView()
        setUpNFTNameLabel()
        setUpRatingImageView()
    }
    
    private func setUpNFTNameLabel() {
        NFTNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(NFTNameLabel)
        NSLayoutConstraint.activate([
            NFTNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            NFTNameLabel.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20),
        ])
        NFTNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    private func setUpRatingImageView() {
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingImageView)
        NSLayoutConstraint.activate([
            ratingImageView.topAnchor.constraint(equalTo: NFTNameLabel.bottomAnchor, constant: 4),
            ratingImageView.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: 20)
        ])
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
    }
}


// MARK: dark theme implementation
private extension NFTTableViewCell {
    private func setUpColorsInCellDependingOnTheme() {
        
    }
}


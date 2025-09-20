//
//  CurrencyCollectionViewCell.swift
//  FakeNFT
//
//  Created by oneche$$$ on 12.09.2025.
//

import UIKit

final class CurrenciesCollectionViewCell: UICollectionViewCell {
    // MARK: UI Elements
    private lazy var cellBackgroundView: UIView = {
        let cellBackgroundView = UIView()
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.layer.masksToBounds = true
        cellBackgroundView.layer.cornerRadius = 12
        cellBackgroundView.backgroundColor = .AppColors.lightGray
        return cellBackgroundView
    }()
    private lazy var currencyBackgroundView: UIView = {
        let currencyBackgroundView = UIView()
        currencyBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        currencyBackgroundView.layer.masksToBounds = true
        currencyBackgroundView.layer.cornerRadius = 6
        currencyBackgroundView.backgroundColor = UIColor(hexString: "#1A1B22")
        return currencyBackgroundView
    }()
    private lazy var currencyImageView: UIImageView = {
        let currencyImageView = UIImageView()
        currencyImageView.translatesAutoresizingMaskIntoConstraints = false
        currencyImageView.backgroundColor = .clear
        return currencyImageView
    }()
    private lazy var currencyNameLabel: UILabel = {
        let currencyNameLabel = UILabel()
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyNameLabel.font = .caption2
        currencyNameLabel.numberOfLines = 1
        currencyNameLabel.textAlignment = .left
        currencyNameLabel.backgroundColor = .clear
        currencyNameLabel.textColor = .AppColors.black
        return currencyNameLabel
    }()
    private lazy var currencyAbbreviationLabel: UILabel = {
        let currencyAbbreviationLabel = UILabel()
        currencyAbbreviationLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyAbbreviationLabel.font = .caption2
        currencyAbbreviationLabel.numberOfLines = 1
        currencyAbbreviationLabel.textAlignment = .left
        currencyAbbreviationLabel.backgroundColor = .clear
        currencyAbbreviationLabel.textColor = UIColor(hexString: "#1C9F00")
        return currencyAbbreviationLabel
    }()
    lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.AppColors.black.cgColor
        borderView.layer.cornerRadius = 12
        borderView.layer.masksToBounds = true
        borderView.backgroundColor = .clear
        borderView.isHidden = true
        return borderView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(currency: Currency) {
        guard let url = URL(string: currency.image) else { return }
        currencyImageView.kf.setImage(with: url)
        currencyNameLabel.text = currency.title
        currencyAbbreviationLabel.text = currency.name
    }
}

// MARK: setup view
private extension CurrenciesCollectionViewCell {
    private func setupView() {
        backgroundColor = .clear
        
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(currencyBackgroundView)
        contentView.addSubview(currencyImageView)
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(currencyAbbreviationLabel)
        contentView.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            currencyBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            currencyBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            currencyBackgroundView.heightAnchor.constraint(equalToConstant: 36)
        ])
        NSLayoutConstraint.activate([
            currencyImageView.centerYAnchor.constraint(equalTo: currencyBackgroundView.centerYAnchor),
            currencyImageView.centerXAnchor.constraint(equalTo: currencyBackgroundView.centerXAnchor),
            currencyImageView.widthAnchor.constraint(equalToConstant: 31.5),
            currencyImageView.heightAnchor.constraint(equalToConstant: 31.5)
        ])
        NSLayoutConstraint.activate([
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyBackgroundView.trailingAnchor, constant: 4),
            currencyNameLabel.topAnchor.constraint(equalTo: currencyBackgroundView.topAnchor),
            currencyNameLabel.widthAnchor.constraint(equalToConstant: 100),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        NSLayoutConstraint.activate([
            currencyAbbreviationLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor),
            currencyAbbreviationLabel.leadingAnchor.constraint(equalTo: currencyBackgroundView.trailingAnchor, constant: 4),
            currencyNameLabel.widthAnchor.constraint(equalToConstant: 100),
            currencyAbbreviationLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: дополнительная настройка цвета рамки в currenciesCollectionView при смене темы (просто установить borderView.layer.borderColor = UIColor.AppColors.black.cgColor ) - недостаточно
extension CurrenciesCollectionViewCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .light {
            borderView.layer.borderColor = UIColor(hexString: "#1A1B22").cgColor
        } else {
            borderView.layer.borderColor = CGColor(gray: 1, alpha: 1)
        }
    }
}

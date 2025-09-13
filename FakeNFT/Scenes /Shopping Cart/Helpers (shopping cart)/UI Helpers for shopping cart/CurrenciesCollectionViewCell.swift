//
//  CurrencyCollectionViewCell.swift
//  FakeNFT
//
//  Created by oneche$$$ on 12.09.2025.
//

import UIKit

final class CurrenciesCollectionViewCell: UICollectionViewCell {
    // MARK: UI Elements
    private let cellBackgroundView = UIView()
    private let currencyBackgroundView = UIView()
    private let currencyImageView = UIImageView()
    private let currencyNameLabel = UILabel()
    private let currencyAbbreviationLabel = UILabel()
    
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
        setUpCellBackgroundView()
        setUpCurrencyBackgroundView()
        setUpCurrencyImageView()
        setUpCurrencyNameLabel()
        setUpCurrencyAbbreviationLabel()
        backgroundColor = .clear
    }
    
    private func setUpCellBackgroundView() {
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        cellBackgroundView.layer.masksToBounds = true
        cellBackgroundView.layer.cornerRadius = 12
        if traitCollection.userInterfaceStyle == .dark {
            cellBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
        } else {
            cellBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
        }
    }
    
    private func setUpCurrencyBackgroundView() {
        currencyBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyBackgroundView)
        NSLayoutConstraint.activate([
            currencyBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            currencyBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            currencyBackgroundView.heightAnchor.constraint(equalToConstant: 36)
        ])
        currencyBackgroundView.layer.masksToBounds = true
        currencyBackgroundView.layer.cornerRadius = 6
        currencyBackgroundView.backgroundColor = UIColor(hexString: "#1A1B22")
    }
    
    private func setUpCurrencyImageView () {
        currencyImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyImageView)
        NSLayoutConstraint.activate([
            currencyImageView.centerYAnchor.constraint(equalTo: currencyBackgroundView.centerYAnchor),
            currencyImageView.centerXAnchor.constraint(equalTo: currencyBackgroundView.centerXAnchor),
            currencyImageView.widthAnchor.constraint(equalToConstant: 31.5),
            currencyImageView.heightAnchor.constraint(equalToConstant: 31.5)
        ])
        currencyImageView.backgroundColor = .clear
    }
    
    private func setUpCurrencyNameLabel() {
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyNameLabel)
        NSLayoutConstraint.activate([
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyBackgroundView.trailingAnchor, constant: 4),
            currencyNameLabel.topAnchor.constraint(equalTo: currencyBackgroundView.topAnchor),
            currencyNameLabel.widthAnchor.constraint(equalToConstant: 100),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        currencyNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        currencyNameLabel.numberOfLines = 1
        currencyNameLabel.textAlignment = .left
        currencyNameLabel.text = "sfafwgtaha"
        currencyNameLabel.backgroundColor = .clear
        if traitCollection.userInterfaceStyle == .dark {
            currencyNameLabel.textColor = .white
        } else {
            currencyNameLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
    
    private func setUpCurrencyAbbreviationLabel() {
        currencyAbbreviationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyAbbreviationLabel)
        NSLayoutConstraint.activate([
            currencyAbbreviationLabel.topAnchor.constraint(equalTo: currencyNameLabel.bottomAnchor),
            currencyAbbreviationLabel.leadingAnchor.constraint(equalTo: currencyBackgroundView.trailingAnchor, constant: 4),
            currencyNameLabel.widthAnchor.constraint(equalToConstant: 100),
            currencyAbbreviationLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        currencyAbbreviationLabel.font = .systemFont(ofSize: 13, weight: .regular)
        currencyAbbreviationLabel.numberOfLines = 1
        currencyAbbreviationLabel.textAlignment = .left
        currencyAbbreviationLabel.text = "tyjk"
        currencyAbbreviationLabel.backgroundColor = .clear
        currencyAbbreviationLabel.textColor = UIColor(hexString: "#1C9F00")
    }
}

// MARK: Dark theme implementation
extension CurrenciesCollectionViewCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .dark {
            cellBackgroundView.backgroundColor = UIColor(hexString: "#2C2C2E")
            currencyNameLabel.textColor = .white
            
        } else {
            cellBackgroundView.backgroundColor = UIColor(hexString: "#F7F7F8")
            currencyNameLabel.textColor = UIColor(hexString: "#1A1B22")
        }
    }
}

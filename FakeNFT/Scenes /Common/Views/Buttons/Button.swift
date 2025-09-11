//
//  Button.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class Button: UIButton {

    // MARK: Properties
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let height: CGFloat = 60
    }

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.AppColors.white, for: .normal)
        setTitleColor(.AppColors.white, for: .disabled)
        titleLabel?.font = .bodyBold
        backgroundColor = isEnabled ? .AppColors.black : .AppColors.lightGray
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

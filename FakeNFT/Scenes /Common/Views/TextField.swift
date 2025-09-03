//
//  TextField.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class TextField: UITextField {

    // MARK: Properties
    private let padding: UIEdgeInsets
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let padding: UIEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 40)
    }

    // MARK: Initializers

    init() {
        self.padding = Constants.padding
        super.init(frame: .zero)
        backgroundColor = .AppColors.lightGray
        textColor = .AppColors.black
        font = .bodyRegular
        layer.cornerRadius = Constants.cornerRadius
        clearButtonMode = .whileEditing
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -10, dy: 0)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

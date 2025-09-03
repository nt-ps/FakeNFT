//
//  TextView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class TextView: UITextView {

    // MARK: Properties
    private let padding: UIEdgeInsets
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let padding: UIEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 40)
    }

    // MARK: Initializers

    init() {
        self.padding = Constants.padding
        super.init(frame: .zero, textContainer: nil)
        
        backgroundColor = .AppColors.lightGray
        textColor = .AppColors.black
        isScrollEnabled = false
        sizeToFit()
        font = .bodyRegular
        layer.cornerRadius = Constants.cornerRadius
        textContainerInset = Constants.padding
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  StackView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 03.09.2025.
//

import UIKit

final class StackView: UIStackView {
    init(spacing: CGFloat, arrangedSubviews: [UIView]) {
        super.init(frame: .zero)
        self.spacing = spacing
        axis = .vertical
        distribution = .fillProportionally
        for subview in arrangedSubviews {
            addArrangedSubview(subview)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

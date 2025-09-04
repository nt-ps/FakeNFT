//
//  Label.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 03.09.2025.
//

import UIKit

final class Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .headline3
        textColor = .AppColors.black
    }
    
    init(withText text: String) {
        super.init(frame: .zero)
        font = .headline3
        textColor = .AppColors.black
        self.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

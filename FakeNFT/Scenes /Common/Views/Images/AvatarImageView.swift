//
//  AvatarImageView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 01.09.2025.
//

import UIKit

final class AvatarImageView: BaseImageView {

    init() {
        super.init(
            size: 70,
            cornerRadius: 35,
            defaultSystemImage: "person.circle.fill",
            fallbackSystemImage: "person"
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAvatar(urlString: String?) {
        setImage(urlString: urlString)
    }
}

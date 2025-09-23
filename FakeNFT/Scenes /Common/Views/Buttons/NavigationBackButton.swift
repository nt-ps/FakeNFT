//
//  NavigationBackButton.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit

final class NavigationBackButton: UIBarButtonItem {

    // MARK: Initializers
    override init() {
        super.init()
        image = .Icons.backward
        style = .plain
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

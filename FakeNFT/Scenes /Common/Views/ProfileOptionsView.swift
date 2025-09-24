//
//  ProfileOptionsView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class ProfileOptionsTableView: UITableView {

    private lazy var tableViewHeightAnchor = heightAnchor.constraint(equalToConstant: 0)

    // MARK: Initializers
    init() {
        super.init(frame: .zero, style: .plain)
        
        separatorStyle = .none
        backgroundColor = .AppColors.white
        tableFooterView = UIView()
        isScrollEnabled = false
        register(ProfileTableViewCell.self)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func updateHeight(maxHeight: CGFloat = 300) {
        layoutIfNeeded()
        tableViewHeightAnchor.constant = min(maxHeight, contentSize.height)
        setupLayout()
    }

    // MARK: Layout
    private func setupLayout() {
        tableViewHeightAnchor.isActive = true
    }
}

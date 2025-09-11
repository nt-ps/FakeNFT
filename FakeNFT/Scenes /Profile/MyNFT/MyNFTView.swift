//
//  MyNFTView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit

// MARK: - MyNFTView
final class MyNFTView: UIView {

    // MARK: Properties
    enum State {
        case loading
        case empty
        case standart
    }

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .AppColors.white
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.register(MyNFTTableViewCell.self)
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .AppColors.black
        label.font = .bodyBold
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicatorView = UIBlockingProgressHUD()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func changeState(_ state: State) {
        switch state {
        case .loading:
            UIBlockingProgressHUD.show()
            emptyLabel.isHidden = true
            tableView.isHidden = true
        case .empty:
            UIBlockingProgressHUD.dismiss()
            emptyLabel.isHidden = false
            tableView.isHidden = true
            emptyLabel.text = L10n.MyNFT.empty
        case .standart:
            UIBlockingProgressHUD.dismiss()
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
    }

    private func setupUI() {
        backgroundColor = .AppColors.white
        emptyLabel.isHidden = true
    }

    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

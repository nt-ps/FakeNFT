//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit
import SkeletonView

protocol ProfileViewDelegate: AnyObject {
    func didTapWebsite()
}

final class ProfileView: UIView {

    // MARK: Properties
    weak var delegate: ProfileViewDelegate?
    
    let tableView = ProfileOptionsTableView()
    
    private let profileInfoView = ProfileInfoView()

    private enum Constants {
        enum ContentView {
            static let horizontalSpacing: CGFloat = 16
        }
        enum TableView {
            static let topInset: CGFloat = 44
            static let horizontalSpacing: CGFloat = 20
            static let maxHeight: CGFloat = 300
        }
        enum DescriptionLabel {
            static let bottomInset: CGFloat = 12
        }
        enum ScrollView {
            static let bottomContentInset: CGFloat = 20
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset.bottom = Constants.ScrollView.bottomContentInset
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.isSkeletonable = true
        return view
    }()

    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .blue
        label.isUserInteractionEnabled = true
        label.isSkeletonable = true
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .AppColors.white
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func configure(with model: ProfileInfoModel) {
        websiteLabel.text = model.website
        profileInfoView.configure(
            name: model.name,
            description: model.description,
            avatarURL: model.avatar
        )
    }

    func changeSkeletonState(isShown: Bool) {
        if isShown {
            contentView.showAnimatedSkeleton()
        } else {
            contentView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }

    func reloadOptions() {
        tableView.reloadData()
    }

    // MARK: Actions
    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapWebsite))
        websiteLabel.addGestureRecognizer(tap)
    }

    @objc private func didTapWebsite() {
        delegate?.didTapWebsite()
    }

    // MARK: Layout
    override func updateConstraints() {
        tableView.layoutIfNeeded()
        tableView.updateHeight(maxHeight: Constants.TableView.maxHeight)
        super.updateConstraints()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        [profileInfoView, websiteLabel, tableView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.ContentView.horizontalSpacing),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.ContentView.horizontalSpacing),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            profileInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: profileInfoView.trailingAnchor),

            websiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            websiteLabel.topAnchor.constraint(equalTo: profileInfoView.bottomAnchor, constant: Constants.DescriptionLabel.bottomInset),
            contentView.trailingAnchor.constraint(equalTo: websiteLabel.trailingAnchor),

            contentView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: Constants.TableView.horizontalSpacing),
            tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: Constants.TableView.topInset),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.TableView.horizontalSpacing),
            contentView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        
        updateConstraints()
    }
}

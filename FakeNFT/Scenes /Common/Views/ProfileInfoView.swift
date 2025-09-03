//
//  ProfileInfoView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 01.09.2025.
//

import UIKit
import SkeletonView

import UIKit
import SkeletonView


final class ProfileInfoView: UIView {
    private enum Constants {
        static let avatarSize: CGFloat = 70
        static let nameLeading: CGFloat = 16
        static let descriptionTop: CGFloat = 20
    }

    // MARK: - Subviews
    let avatarView = AvatarImageView()

    let nameLabel: Label = {
        let label = Label()
        label.numberOfLines = 2
        label.isSkeletonable = true
        return label
    }()

    let descriptionLabel: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .AppColors.white
        textView.textColor = .AppColors.black
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isEditable = false
        textView.sizeToFit()

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .foregroundColor: UIColor.black,
            .font: UIFont.caption2
        ]
        textView.typingAttributes = attributes
        textView.isSkeletonable = true
        return textView
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .AppColors.white
        isSkeletonable = true
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout
    private func setupLayout() {
        
        [avatarView, nameLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),

            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: Constants.nameLeading),
            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.descriptionTop),

            bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
        ])
    }

    // MARK: Update
    func configure(name: String?, description: String?, avatarURL: String?) {
        nameLabel.text = name
        descriptionLabel.text = description ?? "This user hasn't added a description yet."
        
        // Проверяем аватар на специальные символы
        let cleanedAvatarURL = cleanAvatarURL(avatarURL)
        avatarView.setAvatar(urlString: cleanedAvatarURL)
    }
    
    private func cleanAvatarURL(_ url: String?) -> String? {
        guard let url = url else { return nil }
        
        let cleaned = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleaned.isEmpty || cleaned == "-" || cleaned == "." || cleaned == "null" {
            return ""
        }
        
        return cleaned
    }
}

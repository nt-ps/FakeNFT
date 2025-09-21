//
//  EditProfileView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class EditProfileView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let textFieldMaxLength: Int = 100
        static let textViewMaxLength: Int = 400
        enum ContentView {
            static let horizontalSpacing: CGFloat = 16
        }
        enum ImageView {
            static let topInset: CGFloat = 1
            static let size: CGFloat = 70
            static let leftInset: CGFloat = 50
        }
        enum StackView {
            static let smallSpacing: CGFloat = 8
            static let bigSpacing: CGFloat = 24
        }
        enum ScrollView {
            static let bottomInset: CGFloat = 20
        }
        enum Button {
            static let bottomInset: CGFloat = 16
        }
    }

    // MARK: Subviews
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let avatarImageView = AvatarImageView()
    
    let changeAvatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(resource: .Icons.camera), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let nameLabel = Label(withText: L10n.EditProfile.name)
    private let descriptionLabel = Label(withText: L10n.EditProfile.description)
    private let websiteLabel = Label(withText: L10n.EditProfile.website)
    
    private let nameTextField = TextField()
    private let descriptionTextView = TextView()
    private let websiteTextField: TextField = {
        let textField = TextField()
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var nameStackView = StackView(
        spacing: Constants.StackView.smallSpacing,
        arrangedSubviews: [nameLabel, nameTextField]
    )
    
    private lazy var descriptionStackView = StackView(
        spacing: Constants.StackView.smallSpacing,
        arrangedSubviews: [descriptionLabel, descriptionTextView]
    )
    
    private lazy var websiteStackView = StackView(
        spacing: Constants.StackView.smallSpacing,
        arrangedSubviews: [websiteLabel, websiteTextField]
    )
    
    private lazy var stackView = StackView(
        spacing: Constants.StackView.bigSpacing,
        arrangedSubviews: [nameStackView, descriptionStackView, websiteStackView]
    )

    private lazy var saveButton: Button = {
        let button = Button()
        button.setTitle(L10n.EditProfile.Avatar.ChangeAlert.save, for: .normal)
        return button
    }()
    
    lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    lazy var activityIndicatorView = UIBlockingProgressHUD()
    
    // MARK: Properties
    var onSave: ((String, String, String) -> Void)?
    var onCancel: (() -> Void)?
    var onChangeAvatar: (() -> Void)?
    
    private var originalName: String = ""
    private var originalDescription: String = ""
    private var originalWebsite: String = ""
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    private func setupView() {
        backgroundColor = .AppColors.white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [avatarImageView, changeAvatarButton, stackView, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        enableKeyboardDismissOnTap()
        enableKeyboardDismissOnScroll(for: scrollView)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingView)

        saveButton.isHidden = true
        saveButton.isEnabled = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.ContentView.horizontalSpacing),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.ContentView.horizontalSpacing),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2*Constants.ContentView.horizontalSpacing),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.ImageView.topInset),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.ImageView.size),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.ImageView.size),
            
            changeAvatarButton.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor, constant: Constants.ImageView.leftInset),
            changeAvatarButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Button.bottomInset),
            
            stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.StackView.bigSpacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        changeAvatarButton.addTarget(self, action: #selector(changeAvatarTapped), for: .touchUpInside)
        
        [nameTextField, websiteTextField].forEach {
            $0.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        }
        
        nameTextField.delegate = self
        websiteTextField.delegate = self
        nameTextField.returnKeyType = .next
        websiteTextField.returnKeyType = .done
        descriptionTextView.delegate = self
    }
    
    // MARK: Actions
    @objc private func saveButtonTapped() {
        let name = nameTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let website = websiteTextField.text ?? ""
        saveButton.isHidden = true
        saveButton.isEnabled = false
        onSave?(name, description, website)
    }
    
    @objc private func cancelButtonTapped() {
        onCancel?()
    }
    
    @objc private func changeAvatarTapped() {
        onChangeAvatar?()
    }
    
    @objc private func textChanged() {
        let currentName = (nameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let currentDescription = descriptionTextView.text ?? ""
        let currentWebsite = websiteTextField.text ?? ""

        let isNameValid = !currentName.isEmpty
        let isChanged = currentName != originalName ||
                        currentDescription != originalDescription ||
                        currentWebsite != originalWebsite

        let shouldShowSave = isNameValid && isChanged
        saveButton.isHidden = !shouldShowSave
        saveButton.isEnabled = shouldShowSave
    }
    
    // MARK: Methods
    func configure(with profile: ProfileInfoModel) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description ?? ""
        websiteTextField.text = profile.website

        originalName = profile.name
        originalDescription = profile.description ?? ""
        originalWebsite = profile.website
        
        avatarImageView.setAvatar(urlString: profile.avatar)
        
        textChanged()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func showLoading() {
        loadingView.isHidden = false
        UIBlockingProgressHUD.show()
        isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        loadingView.isHidden = true
        UIBlockingProgressHUD.dismiss()
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - UITextViewDelegate
extension EditProfileView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChanged()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            endEditing(true)
            return false
        }
        return true
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            descriptionTextView.becomeFirstResponder()
        } else if textField == websiteTextField {
            endEditing(true)
        }
        return true
    }
}

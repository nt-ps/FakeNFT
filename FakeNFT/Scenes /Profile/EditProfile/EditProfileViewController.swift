//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

protocol EditProfileViewProtocol: AnyObject {
    func configure(with profile: ProfileInfoModel)
    func showLoading()
    func hideLoading()
    func showSuccess()
    func showError(message: String)
    func dismiss()
    func showAvatarOptions()
    func showAvatarChangeAlert()
    func showAvatarDeleteConfirmation()
}

final class EditProfileViewController: UIViewController {
    
    // MARK: Properties
    private let editProfileView = EditProfileView()
    private let presenter: EditProfilePresenterProtocol
    
    // MARK: Initializers
    init(presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    override func loadView() {
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Setup
    private func setupView() {
        let backButton = NavigationBackButton()
        backButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        editProfileView.onSave = { [weak self] name, description, website in
            self?.presenter.didTapSave(name: name, description: description, website: website)
        }
        
        editProfileView.onCancel = { [weak self] in
            self?.presenter.didTapCancel()
        }
        
        editProfileView.onChangeAvatar = { [weak self] in
            self?.presenter.didTapAvatar()
        }
    }
    
    // MARK: Actions
    @objc private func cancelTapped() {
        presenter.didTapCancel()
    }
}

// MARK: - EditProfileViewProtocol
extension EditProfileViewController: EditProfileViewProtocol {
    
    func configure(with profile: ProfileInfoModel) {
        editProfileView.configure(with: profile)
    }
    
    func showLoading() {
        editProfileView.showLoading()
    }
    
    func hideLoading() {
        editProfileView.hideLoading()
    }
    
    func showSuccess() {
        let alertModel = AlertModel(title: "Профиль обновлен",
                                    buttons: [
                                        AlertButton(text: L10n.Alert.ok) { [weak self] in
                                            self?.dismiss()
                                        }
                                    ])
        AlertPresenter.present(in: self, model: alertModel)
    }
    
    func showError(message: String) {
        let alertModel = AlertModel.error(message: message)
        AlertPresenter.present(in: self, model: alertModel)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAvatarOptions() {
        let alertModel = AlertModel(
            title: L10n.EditProfile.Avatar.Alert.title,
            message: nil,
            buttons: [
                AlertButton(text: L10n.EditProfile.Avatar.Alert.change) { [weak self] in
                    self?.presenter.didTapChangeAvatar()
                },
                AlertButton(text: L10n.EditProfile.Avatar.Alert.delete, style: .destructive) { [weak self] in
                    self?.presenter.didTapDeleteAvatar()
                },
                AlertButton(text: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel)
            ],
            preferredStyle: .actionSheet
        )
        AlertPresenter.present(in: self, model: alertModel)
    }
    
    func showAvatarChangeAlert() {
        AlertPresenter.presentTextFieldAlert(
            in: self,
            title: L10n.EditProfile.Avatar.ChangeAlert.title,
            placeholder: "https://example.com/image.jpg",
            currentText: presenter.profile.avatar,
            keyboardType: .URL,
            saveAction: { [weak self] urlString in
                self?.presenter.didTapSaveAvatarURL(urlString)
            }
        )
    }
    
    func showAvatarDeleteConfirmation() {
        let alertModel = AlertModel.avatarDeleteConfirmation { [weak self] in
            self?.presenter.didTapSaveAvatarURL("")
        }
        AlertPresenter.present(in: self, model: alertModel)
    }
}

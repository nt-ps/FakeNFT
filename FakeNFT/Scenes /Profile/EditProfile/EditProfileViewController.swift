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
    
    // MARK: - Properties
    private let editProfileView = EditProfileView()
    private let presenter: EditProfilePresenterProtocol
    
    // MARK: - Initializers
    init(presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
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
    
    // MARK: - Setup
    private func setupView() {
        let backButton = UIButton(type: .system)
        backButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        backButton.setImage(.Icons.backward, for: .normal)
        backButton.tintColor = .AppColors.black
        backButton.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Actions
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
        let alert = UIAlertController(
            title: "Успешно",
            message: "Профиль обновлен",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAvatarOptions() {
        let alert = UIAlertController(
            title: L10n.EditProfile.Avatar.Alert.title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: L10n.EditProfile.Avatar.Alert.change, style: .default) { [weak self] _ in
            self?.presenter.didTapChangeAvatar()
        })
        
        alert.addAction(UIAlertAction(title: L10n.EditProfile.Avatar.Alert.delete, style: .destructive) { [weak self] _ in
            self?.presenter.didTapDeleteAvatar()
        })
        
        alert.addAction(UIAlertAction(title: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showAvatarChangeAlert() {
        let alert = UIAlertController(
            title: L10n.EditProfile.Avatar.ChangeAlert.title,
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "https://example.com/image.jpg"
            textField.text = self.presenter.profile.avatar
            textField.keyboardType = .URL
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        
        let saveAction = UIAlertAction(title: L10n.EditProfile.Avatar.ChangeAlert.save, style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let urlString = textField.text,
                  !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            self?.presenter.didTapSaveAvatarURL(urlString.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        let cancelAction = UIAlertAction(title: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showAvatarDeleteConfirmation() {
        let alert = UIAlertController(
            title: L10n.EditProfile.Avatar.DeleteAlert.title,
            message: L10n.EditProfile.Avatar.DeleteAlert.message,
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: L10n.EditProfile.Avatar.DeleteAlert.delete, style: .destructive) { [weak self] _ in
            self?.presenter.didTapSaveAvatarURL("") // Пустая строка означает удаление аватара
        }
        
        let cancelAction = UIAlertAction(title: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

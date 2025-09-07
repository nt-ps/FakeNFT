//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    var profile: ProfileInfoModel { get }
    func viewDidLoad()
    func didTapSave(name: String, description: String, website: String)
    func didTapCancel()
    func didTapAvatar()
    func didTapChangeAvatar()
    func didTapDeleteAvatar()
    func didTapSaveAvatarURL(_ url: String)
}

struct EditProfileInput {
    let profile: ProfileInfoModel
}

final class EditProfileAssembly {
    
    static func makeModule(input: EditProfileInput) -> EditProfileViewController {
        let presenter = EditProfilePresenter(input: input)
        let viewController = EditProfileViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    // MARK: Properties
    weak var view: EditProfileViewProtocol?
    private let input: EditProfileInput
    private let profileService: ProfileService
    private let profileStorage: ProfileStorage
    
    var profile: ProfileInfoModel {
        input.profile
    }
    
    // MARK: Initializers
    init(input: EditProfileInput,
         profileService: ProfileService = .shared,
         profileStorage: ProfileStorage = .shared) {
        self.input = input
        self.profileService = profileService
        self.profileStorage = profileStorage
    }
    
    // MARK: EditProfilePresenterProtocol
    func viewDidLoad() {
        view?.configure(with: profile)
    }
    
    func didTapSave(name: String, description: String, website: String) {
        let editModel = EditProfileModel(
            avatar: profile.avatar,
            name: name,
            description: description,
            website: website
        )
        
        view?.showLoading()
        
        profileService.editProfile(editModel) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let updatedProfile):
                    self?.profileStorage.profile = updatedProfile
                    self?.profileStorage.onProfileInfoChanged?()
                    self?.view?.showSuccess()
                    self?.view?.dismiss()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func didTapCancel() {
        view?.dismiss()
    }
    
    func didTapAvatar() {
        view?.showAvatarOptions()
    }
    
    func didTapChangeAvatar() {
        view?.showAvatarChangeAlert()
    }
    
    func didTapDeleteAvatar() {
        view?.showAvatarDeleteConfirmation()
    }
    
    func didTapSaveAvatarURL(_ url: String) {
        let cleanedURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedURL.isEmpty || cleanedURL == "-" || cleanedURL == "." || cleanedURL == "null" {
            updateProfileAvatar("")
            return
        }
        
        guard let url = URL(string: cleanedURL), url.scheme != nil else {
            view?.showError(message: L10n.EditProfile.Avatar.Error.invalidURL)
            return
        }
        
        updateProfileAvatar(url.absoluteString)
    }
    
    private func updateProfileAvatar(_ avatarURL: String) {
        let editModel = EditProfileModel(
            avatar: avatarURL,
            name: profile.name,
            description: profile.description ?? "",
            website: profile.website
        )
        
        view?.showLoading()
        
        profileService.editProfile(editModel) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let updatedProfile):
                    self?.profileStorage.profile = updatedProfile
                    self?.profileStorage.onProfileInfoChanged?()
                    
                    self?.view?.configure(with: updatedProfile)
                    
                    self?.view?.showSuccess()
                    print("Avatar updated successfully: \(avatarURL.isEmpty ? "removed" : avatarURL)")
                    
                case .failure(let error):
                    print("Failed to update avatar: \(error)")
                    self?.view?.showError(message: "\(L10n.EditProfile.Avatar.Error.updateFailed): \(error.localizedDescription)")
                }
            }
        }
    }
}

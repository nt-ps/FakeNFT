//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var cells: [ProfileCellType] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didTapEdit()
    func didSelectCell(at index: Int)
    func didTapWebsite()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    
    private let profileService = ProfileService.shared
    private let profileStorage = ProfileStorage.shared
    private var model: ProfileInfoModel?
    
    var cells: [ProfileCellType] {
        [
            .myNFT(model?.nfts.count ?? .zero),
            .favouriteNFT(model?.likes.count ?? .zero)
        ]
    }

    init() {
        let model = profileStorage.profile
        self.model = model
        
        profileStorage.onProfileInfoChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshProfileData()
            }
        }
    }

    func viewDidLoad() {
        if let cachedProfile = profileStorage.profile {
            self.model = cachedProfile
            self.view?.showProfile(model: cachedProfile)
        }
        
        view?.changeSkeletonState(isShown: true)
        fetchProfile { [weak self] result in
            guard let self else { return }
            self.view?.changeSkeletonState(isShown: false)
            switch result {
            case .success(let model):
                self.model = model
                self.view?.showProfile(model: model)
            case .failure(let error):
                let errorMessage = self.formatErrorMessage(error)
                self.view?.showError(message: errorMessage) {
                    self.viewDidLoad()
                }
            }
        }
    }

    func viewWillAppear() {
        refreshProfileData()
    }
    
    private func refreshProfileData() {
        if let updatedProfile = profileStorage.profile {
            self.model = updatedProfile
            self.view?.showProfile(model: updatedProfile)
            self.view?.reloadOptions()
        }
    }

    func didTapEdit() {
        view?.openEditProfile()
    }

    func didSelectCell(at index: Int) {
        switch cells[index] {
        case .myNFT: view?.openMyNFT()
        case .favouriteNFT: view?.openFavouriteNFT()
        }
    }

    func didTapWebsite() {
        view?.openWebsite()
    }
    
    func getCurrentProfile(completion: @escaping (ProfileInfoModel?) -> Void) {
        completion(model)
    }

    // MARK: Methods
    func fetchProfile(completion: @escaping (Result<ProfileInfoModel, Error>) -> Void) {
        profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.updateProfileIfNeeded(model: model)
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func editProfile(editProfileModel: EditProfileModel) {
        profileService.editProfile(editProfileModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.updateProfileIfNeeded(model: model)
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription) {}
            }
        }
    }
    
    private func updateProfileIfNeeded(model: ProfileInfoModel) {
        guard profileStorage.profile != model else { return }
        profileStorage.profile = model
        self.model = model
        view?.reloadOptions()
    }
    
    private func formatErrorMessage(_ error: Error) -> String {
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                return "HTTP Error: \(code). Please check your connection and try again."
            case .urlRequestError(let underlyingError):
                return "Network Error: \(underlyingError.localizedDescription)"
            case .urlSessionError:
                return "Connection Error: Unable to connect to the server."
            case .parsingError:
                return "Data Error: Unable to parse the response from server."
            }
        }
        return "Error: \(error.localizedDescription)"
    }
}

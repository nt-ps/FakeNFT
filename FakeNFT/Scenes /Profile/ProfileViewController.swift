//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 01.09.2025.
//

import UIKit

// Import for EditProfile functionality
import Foundation

protocol ProfileViewProtocol: AnyObject {
    func showProfile(model: ProfileInfoModel)
    func changeSkeletonState(isShown: Bool)
    func reloadOptions()

    func showError(message: String, retryAction: @escaping () -> Void)

    func openEditProfile()
    func openMyNFT()
    func openFavouriteNFT()
    func openWebsite()
}

final class ProfileViewController: UIViewController {

    private enum Constants {
        enum TableView {
            static let height: CGFloat = 54
        }
    }

    private let profileView = ProfileView()
    private let presenter: ProfilePresenterProtocol
    private var profileService: ProfileServiceProtocol

    private var editButton: UIBarButtonItem? {
        navigationItem.rightBarButtonItem
    }

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        
        self.profileService = ProfileService.shared
        
        super.init(nibName: nil, bundle: nil)
        if let presenter = self.presenter as? ProfilePresenter {
            presenter.view = self
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.delegate = self
        configureNavigationBar()
        configureView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    private func configureNavigationBar() {
        let rightButton = UIBarButtonItem(
            image: UIImage(resource: .Icons.edit),
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
        rightButton.tintColor = .AppColors.black
        rightButton.isEnabled = false
        navigationItem.setRightBarButton(rightButton, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func configureView() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
    }

    @objc private func editTapped() {
        presenter.didTapEdit()
    }
}

// MARK: - ProfileViewDelegate
extension ProfileViewController: ProfileViewDelegate {
    func didTapWebsite() {
        presenter.didTapWebsite()
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configCell(label: presenter.cells[indexPath.row].name)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.TableView.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCell(at: indexPath.row)
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {

    func showProfile(model: ProfileInfoModel) {
        profileView.configure(with: model)
        editButton?.isEnabled = true
    }

    func changeSkeletonState(isShown: Bool) {
        profileView.changeSkeletonState(isShown: isShown)
    }

    func reloadOptions() {
        profileView.reloadOptions()
    }

    func showError(message: String, retryAction: @escaping () -> Void) {
        let alertModel = AlertModel(
            title: L10n.Error.title,
            message: message,
            buttons: [
                AlertButton(text: L10n.Error.repeat, action: retryAction),
                AlertButton(text: L10n.Cart.DeleteAlert.cancel, style: .cancel)
            ]
        )
        AlertPresenter.present(in: self, model: alertModel)
    }

    func openEditProfile() {
        if let profilePresenter = presenter as? ProfilePresenter {
            profilePresenter.getCurrentProfile { [weak self] profile in
                guard let self = self, let profile = profile else { return }
                let input = EditProfileInput(profile: profile)
                let vc = EditProfileAssembly.makeModule(input: input)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func openMyNFT() {
        let vc = MyNFTViewController()
        let presenter = MyNFTPresenter(view: vc, profileService: profileService)
        vc.setPresenter(presenter)
        navigationController?.pushViewController(vc, animated: true)
    }

    func openFavouriteNFT() {
        let vc = FavouriteNFTViewController()
        let presenter = FavouriteNFTPresenter(view: vc)
        vc.setPresenter(presenter)
        navigationController?.pushViewController(vc, animated: true)
    }

    func openWebsite() {
        if let urlString = (profileView.subviews.compactMap { ($0 as? UILabel)?.text }.first),
           let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

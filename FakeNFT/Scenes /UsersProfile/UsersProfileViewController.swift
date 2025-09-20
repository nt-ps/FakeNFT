import UIKit
import Kingfisher


protocol UsersProfileViewControllerProtocol: AnyObject {
    func configure(with user: User)
    func navigateToViewController(viewController: UIViewController)
}

final class UsersProfileViewController: UIViewController, UsersProfileViewControllerProtocol {
    private var presenter: UserProfilePresenterProtocol
    private var user: User?
    
    private lazy var profileContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .AppColors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .AppColors.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userWebSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Profile.Website.button, for: .normal)
        button.setTitleColor(.AppColors.black, for: .normal)
        button.titleLabel?.font = .bodyRegular
        button.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.AppColors.black.cgColor
        button.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (button: UIButton, _) in
            self?.updateButtonBorder()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(presenter: UsersProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(false, animated: true)
        setupUI()
        presenter.viewDidLoad()
    }
    
    func configure(with user: User) {
        self.user = user
        nameLabel.text = user.name
        descriptionLabel.text = user.description ?? ""
        
        if let avatarURL = user.avatarURL {
            let placeholder = UIImage(resource: .Icons.profileTab)
            profileImageView.kf.setImage(
                with: avatarURL,
                placeholder: placeholder,
                options: [.transition(.fade(0.2))]
            )
        } else {
            profileImageView.image = UIImage(resource: .Icons.profileTab)
        }
        
        tableView.reloadData()
    }
    
    func navigateToViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .AppColors.white
        view.addSubview(profileContainer)
        view.addSubview(userWebSiteButton)
        view.addSubview(tableView)
        
        tableView.register(UserProfileNFTCollectionCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        profileContainer.addSubview(profileImageView)
        profileContainer.addSubview(nameLabel)
        profileContainer.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            profileContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileContainer.heightAnchor.constraint(equalToConstant: 162),
            
            profileImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            userWebSiteButton.topAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: 28),
            userWebSiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userWebSiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userWebSiteButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: userWebSiteButton.bottomAnchor, constant: 41),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateButtonBorder() {
        userWebSiteButton.layer.borderColor = UIColor.AppColors.black.cgColor
    }
    
    @objc private func websiteButtonTapped() {
        presenter.didTappedUserWebsite()
    }
    
    @objc private func collectionButtonDidTapped() {
        presenter.didTappedUserCollection()
    }
}

extension UsersProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserProfileNFTCollectionCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: user?.nftCount ?? 0)
        
        cell.onAccessoryButtonTapped = { [weak self] in
            self?.presenter.didTappedUserCollection()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

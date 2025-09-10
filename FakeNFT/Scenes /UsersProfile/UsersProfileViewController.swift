import UIKit
import Kingfisher


protocol UsersProfileViewControllerProtocol: AnyObject {
    func configure(with user: User)
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
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .AppColors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .AppColors.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userWebSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.AppColors.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
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
    
    private lazy var accessoryButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: "chevron.right")
        button.setImage(icon, for: .normal)
        button.tintColor = .AppColors.black
        button.sizeToFit()
        button.addTarget(self, action: #selector(collectionButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(presenter: UsersProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
    
    private func setupUI() {
        view.backgroundColor = .AppColors.white
        view.addSubview(profileContainer)
        view.addSubview(userWebSiteButton)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NFTCollectionWWWCell")
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
    
    @objc func websiteButtonTapped() {
        presenter.didTapUserWebsite { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func collectionButtonDidTapped() {}
    
    private func updateButtonBorder() {
        userWebSiteButton.layer.borderColor = UIColor.AppColors.black.cgColor
    }
}

extension UsersProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCollectionWWWCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Коллекция NFT (\(user?.nftCount ?? 0))"
        content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
        content.textProperties.color = .AppColors.black
        
        cell.accessoryView = accessoryButton
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

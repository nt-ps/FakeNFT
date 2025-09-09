import UIKit


final class UsersProfileViewController: UIViewController {
    private var presenter: UserProfilePresenterProtocol
    
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userWebSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.view?.viewDidLoad()
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        descriptionLabel.text = user.description ?? ""
    }
    
    private func setupUI() {
        view.addSubview(profileContainer)
        view.addSubview(userWebSiteButton)
        view.addSubview(tableView)
        
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
            
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -20),
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
        
        @objc func websiteButtonTapped() {}
    }
}

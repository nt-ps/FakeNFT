import UIKit


final class StatisticsViewController: UIViewController {
    private var presenter: StatisticsPresenterProtocol
    private var publishedUsers: [User] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var sortButton = UIBarButtonItem(
        image: UIImage(resource: .Icons.sort),
        style: .plain,
        target: self,
        action: #selector(sortButtonDidTupped)
    )
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.backgroundColor = .AppColors.white
        setupUI()
        activityIndicator.startAnimating()
        presenter.viewDidLoad()
    }
    
    func usersDidUpdated(_ users: [User]) {
        publishedUsers = users
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    private func setupUI() {
        view.backgroundColor = .AppColors.white
        
        sortButton.tintColor = .AppColors.black
        navigationItem.rightBarButtonItem = sortButton
        
        view.addSubview(activityIndicator)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 104),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StatCell.self, forCellReuseIdentifier: "StatCell")
    }
    
    private func showSortAlert() {
        let alertController = UIAlertController(title: "Сортировка",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let byNameAction = UIAlertAction(title: "По имени",
                                         style: .default) {[weak self] _ in
            self?.presenter.sortByName()
        }
        
        let byRatingAction = UIAlertAction(title: "По рейтингу",
                                           style: .default) {[weak self] _ in
            self?.presenter.sortByRating()
        }
        
        let closeAction = UIAlertAction(title: "Закрыть",
                                        style: .cancel)
        
        alertController.addAction(byNameAction)
        alertController.addAction(byRatingAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
    
    @objc func sortButtonDidTupped() {
        showSortAlert()
    }
}

extension StatisticsViewController: UITableViewDataSource,
                                    UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        publishedUsers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "StatCell",
            for: indexPath
        ) as? StatCell else {
            return UITableViewCell()
        }
        
        let user = publishedUsers[indexPath.row]
        cell.configure(with: user, position: indexPath.row + 1)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == publishedUsers.count - 1 {
            presenter.loadMoreUsers()
        }
    }
}

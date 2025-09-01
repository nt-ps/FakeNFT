import UIKit


final class StatisticsViewController: UIViewController {
    let servicesAssembly: ServicesAssembly
    
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
    
    private let mockUsers: [User] = [
           User(id: 1, name: "Bill", username: "@bill", nftCount: 2, avatarURL: nil),
           User(id: 2, name: "Alla", username: "@alla", nftCount: 4, avatarURL: nil),
           User(id: 3, name: "Mads", username: "@mads", nftCount: 6, avatarURL: nil),
           User(id: 4, name: "Timothée", username: "@timothee", nftCount: 8, avatarURL: nil),
           User(id: 5, name: "Lea", username: "@lea", nftCount: 9, avatarURL: nil),
           User(id: 6, name: "Eric", username: "@eric", nftCount: 11, avatarURL: nil)
       ]

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .AppColors.white
        
        navigationItem.rightBarButtonItem = sortButton
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 104),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StatCell.self, forCellReuseIdentifier: "StatCell")
    }
    
    @objc func sortButtonDidTupped() {
        
    }
}

extension StatisticsViewController: UITableViewDataSource,
                                    UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        mockUsers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "StatCell",
            for: indexPath
        ) as? StatCell else {
            return UITableViewCell()
        }
        
        let user = mockUsers[indexPath.row]
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
}

struct User: Hashable {
    let id: Int
    let name: String
    let username: String
    let nftCount: Int
    let avatarURL: String?
}

import UIKit

typealias CatalogueDataSourceSnapshot = NSDiffableDataSourceSnapshot<CatalogueTableSection, Collection>

// MARK: - Protocol

protocol CatalogueViewControllerProtocol: AnyObject {
    var presenter: CataloguePresenterProtocol { get }
    
    func updateTableViewAnimated(from newCollections: [Collection])
}

// MARK: - Implementation

final class CatalogueViewController: UITableViewController, CatalogueViewControllerProtocol {
    
    // TODO: При добавлении сети добавить ProgressHUD.
    
    // MARK: - Views
    
    private lazy var sortButton: UIBarButtonItem = .init(
        image: UIImage(resource: .Icons.sort),
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    private lazy var sortAlert: UIAlertController = {
        // TODO: Сохранять выбранный способ сортировки в UserDefaults.
        
        let alert = UIAlertController(
            title: L10n.SortAlert.title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(
            title: L10n.SortAlert.byName,
            style: .default
        ) { [weak self] _ in
            self?.sortAndUpdateTable(by: .name)
        }
        
        let sortByAmountAction = UIAlertAction(
            title: L10n.SortAlert.byAmount,
            style: .default
        ) { [weak self] _ in
            self?.sortAndUpdateTable(by: .nfts)
        }
        
        let cancelAction = UIAlertAction(title: L10n.SortAlert.close, style: .cancel)
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByAmountAction)
        alert.addAction(cancelAction)
        
        return alert
    } ()
    
    // MARK: - UI Properties
    
    private let tableYSpacing: CGFloat = 10
    private let estimatedRowHeight: CGFloat = 150
    
    // MARK: - Internal Properties
    
    let presenter: CataloguePresenterProtocol
    
    // MARK: - Private Properties

    private lazy var dataSource = CatalogueDataSource(tableView)
    
    // MARK: - Initializers

    init(presenter: CataloguePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CatalogueViewController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .AppColors.white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .AppColors.white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = sortButton
        
        tableView.register(
            CatalogueTableCell.self,
            forCellReuseIdentifier: CatalogueTableCell.defaultReuseIdentifier
        )
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        tableView.contentInset = UIEdgeInsets(
            top: tableYSpacing, left: 0, bottom: tableYSpacing, right: 0
        )
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        presenter.fetchNextPage()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapSortButton() {
        // TODO: Фрагмент кода для открытия WebView.
        //       В будущем перенести на экран коллекции.
        /*
        guard let url = URL(string: "https://ya.ru/") else { return }
        
        let assembly = WebViewAssembly()
        let viewController = assembly.build(with: URLRequest(url: url))
        viewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(viewController, animated: true)
         */
        
        present(sortAlert, animated: true)
    }
    
    // MARK: - Catalogue View Controller Protocol
    
    func updateTableViewAnimated(from newCollections: [Collection]) {
        var snapshot = CatalogueDataSourceSnapshot()
        snapshot.appendSections([CatalogueTableSection.main])
        snapshot.appendItems(newCollections, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Table Delegate Methods
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // TODO: Использовать при выборе ячейки.
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if
            indexPath.section == tableView.numberOfSections - 1,
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            presenter.fetchNextPage()
        }
    }
    
    // MARK: - UI Updates
    
    private func sortAndUpdateTable(by field: CollectionFields) {
        if presenter.sort(by: field) {
            presenter.fetchNextPage()
            scrollToTop()
        }
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    // MARK: - Private Methods
    
    func reuse<T: UITableViewCell & ReuseIdentifying>(
        _ type: T.Type,
        indexPath: IndexPath
    ) -> T? {
        tableView.dequeueReusableCell(
            withIdentifier: T.defaultReuseIdentifier,
            for: indexPath
        ) as? T
    }
}

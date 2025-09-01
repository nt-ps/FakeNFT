import UIKit

protocol CatalogueViewControllerProtocol: AnyObject {
    var presenter: CataloguePresenterProtocol { get }
    
    func updateTableViewAnimated(from newСollections: [Collection])
}

final class CatalogueViewController: UITableViewController, CatalogueViewControllerProtocol {
    
    // MARK: - Views
    
    private lazy var sortButton: UIBarButtonItem = .init(
        image: UIImage(resource: .filtrationButton),
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    private lazy var sortAlert: UIAlertController = {
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
    
    private var collections: [Collection] = []
    
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
            forCellReuseIdentifier: CatalogueTableCell.reuseIdentifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    func updateTableViewAnimated(from newСollections: [Collection]) {
        let oldCollections = collections
        collections = newСollections
        
        let oldNumber = oldCollections.count
        let newNumber = newСollections.count
        let difference = newNumber - oldNumber
        
        if difference != 0 {
            tableView.performBatchUpdates {
                if difference > 0 {
                    let insertedIndexPaths = (oldNumber..<newNumber).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    tableView.insertRows(at: insertedIndexPaths, with: .automatic)
                } else {
                    let deletedIndexPaths = (newNumber..<oldNumber).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    tableView.deleteRows(at: deletedIndexPaths, with: .automatic)
                }
                
                let reloadedIndexPaths: [IndexPath] = (0..<min(oldNumber, newNumber)).reduce(
                    into: []
                ) { (result, i) in
                    if oldCollections[i].id != newСollections[i].id {
                        let indexPath = IndexPath(row: i, section: 0)
                        result.append(indexPath)
                    }
                }
                tableView.reloadRows(at: reloadedIndexPaths, with: .automatic)
                
            } completion: { _ in }
        }
    }
    
    // MARK: - Table Data Source Methods
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int { collections.count }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueTableCell.reuseIdentifier,
            for: indexPath
        )
                
        guard let catalogueTableCell = cell as? CatalogueTableCell else {
            return UITableViewCell()
        }
        
        configCell(for: catalogueTableCell, with: indexPath)
        
        return catalogueTableCell
    }
    
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == collections.count {
            presenter.fetchNextPage()
        }
    }
    
    // MARK: - Tabel Delegate Methods
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // TODO: Использовать при выборе ячейки.
    }
    
    // MARK: - UI Updates
    
    private func configCell(for cell: CatalogueTableCell, with indexPath: IndexPath) {
        let collection = collections[indexPath.row]
        configCell(cell, from: collection)
    }
    
    private func configCell(_ cell: CatalogueTableCell, from collection: Collection) {
        cell.cover = collection.coverImage
        cell.name = collection.name
        cell.counterValue = collection.nfts.count
    }
    
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
}

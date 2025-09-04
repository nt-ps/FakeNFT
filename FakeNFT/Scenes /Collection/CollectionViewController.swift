import UIKit

typealias CollectionDataSourceSnapshot = NSDiffableDataSourceSnapshot<CollectionCollectionSection, Nft>

// MARK: - Protocol

protocol CollectionViewControllerProtocol { }

// MARK: - Implementation

final class CollectionViewController: UICollectionViewController, CollectionViewControllerProtocol {
    
    // MARK: - Internal Properties
    
    let presenter: CollectionPresenterProtocol
    
    // MARK: - Private Properties

    private lazy var dataSource = CollectionDataSource(collectionView)
    
    // MARK: - Initializers

    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CollectionViewController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        // TODO: Test
        updateCollectionViewAnimated()
    }
    
    // TODO: Test
    func updateCollectionViewAnimated() {
        var snapshot = CollectionDataSourceSnapshot()
        snapshot.appendSections([CollectionCollectionSection.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

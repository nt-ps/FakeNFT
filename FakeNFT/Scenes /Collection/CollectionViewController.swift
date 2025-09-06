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

    init(presenter: CollectionPresenterProtocol, collectionViewLayout: UICollectionViewLayout) {
        self.presenter = presenter
        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CollectionViewController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        collectionView.register(CollectionCollectionCell.self)
        collectionView.register(
            CollectionCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
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

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        /*
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
         */
        CGSize(
            width: collectionView.frame.width,
            height: 500
        )
    }
}

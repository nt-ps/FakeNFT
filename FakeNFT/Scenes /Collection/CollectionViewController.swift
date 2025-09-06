import UIKit

typealias CollectionDataSourceSnapshot = NSDiffableDataSourceSnapshot<CollectionCollectionSection, Nft>

// MARK: - Protocol

protocol CollectionViewControllerProtocol { }

// MARK: - Implementation

final class CollectionViewController: UICollectionViewController, CollectionViewControllerProtocol {
    
    // MARK: - Internal Properties
    
    let presenter: CollectionPresenterProtocol
    
    // MARK: - Private Properties

    private lazy var dataSource: CollectionDataSource = .init(collectionView)
    
    private static let layout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    } ()
    
    // MARK: - Initializers

    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(collectionViewLayout: CollectionViewController.layout)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CollectionViewController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .AppColors.white
        
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

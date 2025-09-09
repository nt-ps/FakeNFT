import UIKit

typealias CollectionDataSourceSnapshot = NSDiffableDataSourceSnapshot<CollectionCollectionSection, Nft>

// MARK: - Protocol

protocol CollectionViewControllerProtocol: AnyObject {
    var presenter: CollectionPresenterProtocol { get }
}

// MARK: - Implementation

final class CollectionViewController: UICollectionViewController, CollectionViewControllerProtocol {
    
    // MARK: - Internal Properties
    
    let presenter: CollectionPresenterProtocol
    
    // MARK: - Private Properties

    private lazy var dataSource: CollectionDataSource = .init(collectionView)
    
    // MARK: - UI Properties
    
    private static var cellPerGroup: CGFloat = 3
    private static var cellSpacing: CGFloat = 8
    private static var groupXSpacing: CGFloat = 16
    private static var sectionTopSpacing: CGFloat = 24
    private static var sectionBottomSpacing: CGFloat = 20
    
    // MARK: - Initializers

    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        let layout = CollectionViewController.createLayout(withHeader: true)
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("\(String(describing: CollectionViewController.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundColor = .AppColors.white
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.compactAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollAppearance
        
        collectionView.backgroundColor = .AppColors.white
        
        collectionView.register(CollectionCollectionCell.self)
        collectionView.register(
            CollectionCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        collectionView.contentInsetAdjustmentBehavior = .never
    
        updateCollectionViewAnimated() // TODO: Удалить!
    }
    
    // TODO: Удалить!
    func updateCollectionViewAnimated() {
        var snapshot = CollectionDataSourceSnapshot()
        snapshot.appendSections([CollectionCollectionSection.main])
        snapshot.appendItems(MockData.nfts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Overriden Methods

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentYOffset = scrollView.contentOffset.y
        if contentYOffset <= 0 {
            guard
                let header = collectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionHeader,
                    at: IndexPath(row: 0, section: 0)
                ) as? CollectionCollectionHeader
            else { return }

            header.stretch(to: -contentYOffset)
        }
    }
    
    // MARK: - Private Mathods
    
    private static func createLayout(withHeader: Bool) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / cellPerGroup),
            heightDimension: .estimated(44)
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
        group.interItemSpacing = .fixed(cellSpacing)
        group.contentInsets = .init(
            top: 0,
            leading: groupXSpacing,
            bottom: 0,
            trailing: groupXSpacing
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = cellSpacing
        section.contentInsets = .init(
            top: sectionTopSpacing,
            leading: 0,
            bottom: sectionBottomSpacing,
            trailing: 0
        )
        
        if withHeader {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

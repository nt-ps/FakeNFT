import UIKit

// MARK: - Collection View Section Model

enum CollectionCollectionSection: Int, CaseIterable {
    case main
}

// MARK: - Data Source Implementation

final class CollectionDataSource: UICollectionViewDiffableDataSource<CollectionCollectionSection, Nft> {
    
    // MARK: - Internal Properties
    
    private let presenter: CollectionPresenterProtocol?
    
    // MARK: - Initializers
    
    init(
        _ collectionView: UICollectionView,
        presenter: CollectionPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(
            collectionView: collectionView
        ) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell: CollectionCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            // TODO: Добавить настройку ячейки при протягивании сети.
            return cell
        }
    }
    
    // MARK: - Overridden Methods
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader
        {
            let header: CollectionCollectionHeader = collectionView.dequeueReusableSupplementaryView(
                indexPath: indexPath,
                kind: kind
            )
            // TODO: Добавить настройку хэдера при протягивании сети.
            return header
        }
        
        return UICollectionViewCell()
    }
}

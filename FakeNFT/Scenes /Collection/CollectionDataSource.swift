import UIKit

// MARK: - Collection View Section Model

enum CollectionCollectionSection: Int, CaseIterable {
    case main
}

// MARK: - Data Source Implementation

final class CollectionDataSource: UICollectionViewDiffableDataSource<CollectionCollectionSection, Nft> {
    
    // MARK: - Internal Properties
    
    private let presenter: CollectionPresenterProtocol
    private let headerDelegate: CollectionCollectionHeaderDelegate
    private let cellDelegate: CollectionCollectionCellDelegate
    
    // MARK: - Initializers
    
    init(
        _ collectionView: UICollectionView,
        presenter: CollectionPresenterProtocol,
        headerDelegate: CollectionCollectionHeaderDelegate,
        cellDelegate: CollectionCollectionCellDelegate
    ) {
        self.presenter = presenter
        self.headerDelegate = headerDelegate
        self.cellDelegate = cellDelegate
        super.init(
            collectionView: collectionView
        ) { (collectionView, indexPath, nft) -> UICollectionViewCell? in
            let cell: CollectionCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            
            cell.delegate = cellDelegate
            cell.image = nft.images.first
            cell.rating = UInt(nft.rating)
            cell.name = nft.name
            cell.price = nft.price
            
            return cell
        }
    }
    
    // MARK: - Overridden Methods
    
    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if
            kind == UICollectionView.elementKindSectionHeader,
            let collection = presenter.collection
        {
            let header: CollectionCollectionHeader = collectionView.dequeueReusableSupplementaryView(
                indexPath: indexPath,
                kind: kind
            )
            
            header.delegate = headerDelegate
            header.cover = collection.cover
            header.name = collection.name
            // TODO: Добавить поля:
            // header.authorName = ...
            // header.authorWebsite = ...
            header.descriptionText = collection.description
            
            return header
        }
        
        return UICollectionViewCell()
    }
}

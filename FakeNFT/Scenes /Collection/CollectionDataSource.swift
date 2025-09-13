import UIKit

// MARK: - Collection View Section Model

enum CollectionCollectionSection: Int, CaseIterable {
    case main
}

// MARK: - Data Source Implementation

final class CollectionDataSource: UICollectionViewDiffableDataSource<CollectionCollectionSection, Nft> {
    
    // MARK: - Internal Properties
    
    private let presenter: CollectionPresenterProtocol?
    private let headerDelegate: CollectionCollectionHeaderDelegate?
    
    // MARK: - Initializers
    
    init(
        _ collectionView: UICollectionView,
        presenter: CollectionPresenterProtocol,
        headerDelegate: CollectionCollectionHeaderDelegate
    ) {
        self.presenter = presenter
        self.headerDelegate = headerDelegate
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
        if
            kind == UICollectionView.elementKindSectionHeader,
            let collection = presenter?.collection
        {
            let header: CollectionCollectionHeader = collectionView.dequeueReusableSupplementaryView(
                indexPath: indexPath,
                kind: kind
            )
            configHeader(header, from: collection)
            return header
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - Header Methods
    
    private func configHeader(_ header: CollectionCollectionHeader, from collection: Collection) {
        header.delegate = headerDelegate
        header.cover = collection.cover
        header.name = collection.name
        // TODO: Добавить поля.
        // header.authorName = ...
        // header.authorWebsite = ...
        header.descriptionText = collection.description
    }
}

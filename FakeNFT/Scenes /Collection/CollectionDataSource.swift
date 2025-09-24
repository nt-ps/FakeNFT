import UIKit

// MARK: - Collection View Section Model

enum CollectionCollectionSection: Int, CaseIterable {
    case main
}

// MARK: - Data Source Implementation

final class CollectionDataSource: UICollectionViewDiffableDataSource<CollectionCollectionSection, NftCellModel> {
    
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
            cell.rating = nft.rating
            cell.name = nft.name
            cell.price = nft.price
            cell.isLiked = nft.isLiked
            cell.inCart = nft.inCart
            
            if let firstImageUrlString = nft.images.first {
                cell.image = URL(string: firstImageUrlString)
            }
            
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
            let model = presenter.headerModel
        {
            let header: CollectionCollectionHeader = collectionView.dequeueReusableSupplementaryView(
                indexPath: indexPath,
                kind: kind
            )
            
            header.delegate = headerDelegate
            header.cover = model.cover
            header.name = model.name
            header.descriptionText = model.description
            header.authorName = model.authorName
            header.authorWebsite = model.authorWebsite
            
            return header
        }
        
        return UICollectionViewCell()
    }
}

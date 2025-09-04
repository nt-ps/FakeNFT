import UIKit

// MARK: - Table View Section Model

enum CatalogueTableSection: Int, CaseIterable {
    case main
}

// MARK: - Data Source Implementation

final class CatalogueDataSource: UITableViewDiffableDataSource<CatalogueTableSection, Collection> {
    
    // MARK: - Initializers
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            guard
                let cell = tableView.reuse(CatalogueTableCell.self, indexPath: indexPath)
            else { return nil }
            
            CatalogueDataSource.configCell(cell, from: item)
            
            return cell
        }
    }
    
    // MARK: - Cell Methods
    
    private static func configCell(_ cell: CatalogueTableCell, from collection: Collection) {
        cell.cover = collection.coverImage
        cell.name = collection.name
        cell.counterValue = collection.nfts.count
    }
}

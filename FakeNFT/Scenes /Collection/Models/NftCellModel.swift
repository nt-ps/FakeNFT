import Foundation

struct NftCellModel: Hashable {
    
    // MARK: - Internal Properties
    
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    
    var isLiked: Bool
    var inCart: Bool
    
    // MARK: - Hashable Protocol
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.isLiked == rhs.isLiked && lhs.inCart == rhs.inCart
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

import Foundation

enum NftFields: String, CodingKey {
    case createdAt, name, images, rating, description, price, author, id
}

struct Nft: Decodable, Hashable {
    
    // MARK: - Internal Properties
    
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    
    // MARK: - Hashable Protocol
    
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

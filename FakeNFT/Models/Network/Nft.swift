import Foundation

enum NftFields: String, CodingKey {
    case createdAt, name, images, rating, description, price, author, id
}

struct Nft: Decodable, Hashable {
    
    // MARK: - Internal Properties
    
    let createdAt: Date
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NftFields.self)
        
        let dateString = try container.decode(String.self, forKey: .createdAt)
        guard
            let date = DateFormatter.defaultDateFormatter.date(from: dateString)
        else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [],
                    debugDescription: "Incorrect date format."
                )
            )
        }
        createdAt = date
        
        name = try container.decode(String.self, forKey: .name)
        images = try container.decode([URL].self, forKey: .images)
        rating = try container.decode(Int.self, forKey: .rating)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Float.self, forKey: .price)
        author = try container.decode(String.self, forKey: .author)
        id = try container.decode(String.self, forKey: .id)
    }
    
    // MARK: - Hashable Protocol
    
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

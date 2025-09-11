import Foundation
import UIKit // TODO: Удалить после того, как будет протянута сеть.

enum NftFields: String, CodingKey {
    case createdAt, name, images, rating, description, price, author, id
}

struct Nft: Decodable {
    
    // MARK: - Internal Properties
    
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    
    let coverImage: UIImage? // TODO: Удалить после того, как будет протянута сеть.
    
    // MARK: - Initializers
    
    // TODO: Удалить после того, как будет протянута сеть.
    init(
        name: String,
        images: [String] = [],
        coverImage: UIImage?,
        rating: Int,
        price: Float,
        id: String,
        author: String = ""
    ) {
        self.createdAt = Date()
        self.name = name
        self.images = images
        self.rating = rating
        self.description = ""
        self.price = price
        self.author = author
        self.id = id
        self.coverImage = coverImage
    }
    
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
        images = try container.decode([String].self, forKey: .images)
        rating = try container.decode(Int.self, forKey: .rating)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Float.self, forKey: .price)
        author = try container.decode(String.self, forKey: .author)
        id = try container.decode(String.self, forKey: .id)
        
        coverImage = nil // TODO: Удалить после того, как будет протянута сеть.
    }
}

import Foundation
import UIKit // TODO: Удалить после того, как будет протянута сеть.

enum CollectionFields: String, CodingKey {
    case createdAt, name, cover, nfts, description, author, id
}

struct Collection: Decodable, Hashable {
    
    // MARK: - Internal Properties
    
    let createdAt: Date
    let name: String
    let cover: URL? // TODO: Удалить опционал после того, как будет протянута сеть.
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    
    let coverImage: UIImage? // TODO: Удалить после того, как будет протянута сеть.
    
    // MARK: - Initializers
    
    // TODO: Удалить после того, как будет протянута сеть.
    init(
        name: String,
        coverImage: UIImage?,
        nfts: [String],
        description: String,
        author: String,
        id: String
    ) {
        self.createdAt = Date()
        self.name = name
        self.coverImage = coverImage
        self.cover = nil
        self.nfts = nfts
        self.description = description
        self.author = author
        self.id = id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CollectionFields.self)
        
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
        cover = try container.decode(URL.self, forKey: .cover)
        nfts = try container.decode([String].self, forKey: .nfts)
        description = try container.decode(String.self, forKey: .description)
        author = try container.decode(String.self, forKey: .author)
        id = try container.decode(String.self, forKey: .id)
        
        coverImage = nil // TODO: Удалить после того, как будет протянута сеть.
    }
    
    // MARK: - Hashable Protocol
    
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

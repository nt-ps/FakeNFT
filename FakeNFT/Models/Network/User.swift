import Foundation

struct User: Decodable, Hashable {
    let id: String
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let rating: Int
    
    var nftCount: Int {
        return nfts.count
    }
    var avatarURL: URL? {
        guard let avatarString = avatar else { return nil }
        return URL(string: avatarString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar, description, website, nfts, rating
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        nfts = try container.decode([String].self, forKey: .nfts)
        
        if let ratingInt = try? container.decode(Int.self, forKey: .rating) {
            rating = ratingInt
        } else if let ratingString = try? container.decode(String.self, forKey: .rating),
                  let ratingInt = Int(ratingString) {
            rating = ratingInt
        } else {
            print("У пользователя \(name) выставлен не корректный рейтинг")
            rating = 0
        }
    }
}

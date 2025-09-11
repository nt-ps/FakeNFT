import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    static let token = "9d1a8c12-5515-4d8b-a683-c4c2f1148d62"
    
    enum Endpoint {
        case collections
        case nfts
        case nftById(id: String)
        case currencies
        case currencyById(id: String)
        case orders
        case paymentById(id: String)
        case profile
        case users
        case userById(id: String)
        
        static var baseURL: URL { URL(string: RequestConstants.baseURL)! }
        
        var path: String {
            switch self {
            case .collections: return "/api/v1/collections"
            case .nfts: return "/api/v1/nft"
            case .nftById(let id): return "/api/v1/nft/\(id)"
            case .currencies: return "/api/v1/currencies"
            case .currencyById(let id): return"/api/v1/currencies/\(id)"
            case .orders: return "/api/v1/orders/1"
            case .paymentById(let id): return "/api/v1/orders/1/payment/\(id)"
            case .profile: return "/api/v1/profile/1"
            case .users: return "/api/v1/users"
            case .userById(let id): return "/api/v1/users/\(id)"
            }
        }
        
        var url: URL? {
            switch self {
            case .collections: return URL(string: Endpoint.collections.path, relativeTo: Endpoint.baseURL)
            case .nfts: return URL(string: Endpoint.nfts.path, relativeTo: Endpoint.baseURL)
            case .nftById(let id): return URL(string: Endpoint.nftById(id: id).path, relativeTo: Endpoint.baseURL)
            case .currencies: return URL(string: Endpoint.currencies.path, relativeTo: Endpoint.baseURL)
            case .currencyById(id: let id): return URL(string: Endpoint.currencyById(id: id).path, relativeTo: Endpoint.baseURL)
            case .orders: return URL(string: Endpoint.orders.path, relativeTo: Endpoint.baseURL)
            case .paymentById(let id): return URL(string: Endpoint.paymentById(id: id).path, relativeTo: Endpoint.baseURL)
            case .profile: return URL(string: Endpoint.profile.path, relativeTo: Endpoint.baseURL)
            case .users: return URL(string: Endpoint.users.path, relativeTo: Endpoint.baseURL)
            case .userById(let id): return URL(string: Endpoint.userById(id: id).path, relativeTo: Endpoint.baseURL)
            }
        }
    }
}

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var query: Query? { get }
    var dto: Dto? { get }
}

protocol Dto {
    func asDictionary() -> [String: String]
}

protocol Query {
    var dictionary: [String: String] { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var query: Encodable? { nil }
    var dto: Encodable? { nil }
}

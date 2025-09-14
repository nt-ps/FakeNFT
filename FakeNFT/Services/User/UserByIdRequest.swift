import Foundation

// TODO: Скопировал реализацию Семена.
//       При слитии актуализировать.
struct UserByIdRequest: NetworkRequest {
    var dto: Dto?
    var query: Query?
    
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(userId)")
    }
    
    var httpMethod: HttpMethod = .get
    
    init(userId: String) {
        self.userId = userId
    }
}

import Foundation

typealias UserCompletion = (Result<[User], Error>) -> Void

protocol UserServiceProtocol {
    func loadUsers(page: Int, completion: @escaping UserCompletion)
}

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUsers(page: Int, completion: @escaping UserCompletion) {
        let request = UsersRequest(page: page)
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

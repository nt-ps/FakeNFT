import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void
typealias UserCompletion = (Result<User, Error>) -> Void

protocol UserServiceProtocol {
    func loadUsers(page: Int, size: Int, sortBy: String, completion: @escaping UsersCompletion)
    func loadUser(by id: String, completion: @escaping UserCompletion)
}

extension UserServiceProtocol {
    func loadUsers(page: Int, size: Int, sortBy: String, completion: @escaping UsersCompletion) {}
    
    func loadUser(by id: String, completion: @escaping UserCompletion){}
}

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    static func serverSortBy(for sortType: StatisticsSortType) -> String {
        switch sortType {
        case .rating:
            return "rating"
        case .name:
            return "name"
        }
    }
    
    func loadUsers(page: Int, size: Int, sortBy: String, completion: @escaping UsersCompletion) {
        let request = UsersRequest(page: page, size: size, sortBy: sortBy)
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadUser(by id: String, completion: @escaping UserCompletion) {
        let request = UserByIdRequest(userId: id)
        networkClient.send(request: request, type: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

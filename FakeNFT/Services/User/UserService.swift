import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void
typealias UserCompletion = (Result<User, Error>) -> Void // TODO: Скопировал реализацию Семена.

protocol UserServiceProtocol {
    func loadUsers(page: Int, completion: @escaping UsersCompletion)
    func loadUser(by id: String, completion: @escaping UserCompletion) // TODO: Скопировал реализацию Семена.
}

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUsers(page: Int, completion: @escaping UsersCompletion) {
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
    
    // TODO: Скопировал реализацию Семена.
    //       При слитии актуализировать.
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

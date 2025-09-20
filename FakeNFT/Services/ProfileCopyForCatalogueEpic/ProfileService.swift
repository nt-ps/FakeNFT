import Foundation

// TODO: Копия реализации Аминыс о следующими изменениями:
//
//       - Метод sendLikeRequest перенесен сюда из NFTImageView.
//         Добавил в него complition, убрал лишние методы и networkClient.
//         Заменил входные параметры nftId и isLiked на likes.
//
//       Помнить про это при слиянии.

// MARK: - Protocol
protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<ProfileInfoModel, Error>) -> Void)
    func editProfile(_ editProfileModel: EditProfileModel, completion: @escaping (Result<ProfileInfoModel, Error>) -> Void)
    func getNFTs(completion: @escaping (Result<[Nft], Error>) -> Void)
    func sendLikeRequest(likes: [String], completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - Implementation
final class ProfileService: ProfileServiceProtocol {

    // MARK: Properties
    static let shared = ProfileService()
    private let networkClient: NetworkClient

    // MARK: Initializers
    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: Methods
    func fetchProfile(completion: @escaping (Result<ProfileInfoModel, Error>) -> Void) {
        let request = GetProfileRequest()
        print("Fetching profile from: \(request.endpoint?.absoluteString ?? "nil")")
        networkClient.send(request: request, type: ProfileInfoModel.self) { result in
            switch result {
            case .success(let model):
                print("Profile loaded successfully:")
                print("Name: \(model.name)")
                print("Description: \(model.description ?? "nil")")
                print("Website: \(model.website)")
                print("NFTs count: \(model.nfts.count)")
                print("Likes count: \(model.likes.count)")
                
                completion(.success(model))
            case .failure(let error):
                print("Profile fetch failed: \(error)")
                completion(.failure(error))
            }
        }
    }

    func editProfile(
        _ editProfileModel: EditProfileModel,
        completion: @escaping (Result<ProfileInfoModel, Error>) -> Void
    ) {
        let request = EditProfileRequest(model: editProfileModel)
        networkClient.send(request: request, type: ProfileInfoModel.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNFTs(completion: @escaping (Result<[Nft], Error>) -> Void) {
        fetchProfile { result in
            switch result {
            case .success(let profile):
                let nftIds = profile.nfts
                
                guard !nftIds.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                self.loadNFTs(ids: nftIds, completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendLikeRequest(
        likes: [String],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let request = SetLikesRequest(likes: likes)
        networkClient.send(request: request, type: ProfileInfoModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(true))
                    break
                case .failure(let error):
                    print("Like request failed: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: Private
    
    private func loadNFTs(ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void) {
        let group = DispatchGroup()
        var nftModels: [Nft] = []
        var lastError: Error?
        
        for id in ids {
            group.enter()
            
            let request = NftRequest(id: id)
            networkClient.send(request: request, type: Nft.self) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let nft):
                    nftModels.append(nft)
                    
                case .failure(let error):
                    lastError = error
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = lastError {
                completion(.failure(error))
            } else {
                completion(.success(nftModels))
            }
        }
    }
}

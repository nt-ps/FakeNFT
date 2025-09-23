import Foundation

typealias NftsCompletion = (Result<[Nft], Error>) -> Void
typealias NftCompletion = (Result<Nft, Error>) -> Void

// MARK: - Protocol

protocol NftService {
    func loadNfts(sortBy sortField: NftFields?, completion: @escaping NftsCompletion)
    func loadNfts(ids: [String], completion: @escaping NftsCompletion)
    
    func loadNft(id: String, completion: @escaping NftCompletion)
}

// MARK: - Error

enum NftServiceError: Error {
    case failedToLoadNfts([String])
}

// MARK: - Implementation

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNfts(
        sortBy sortField: NftFields? = nil,
        completion: @escaping NftsCompletion
    ) {
        let query = NftsApiQuery(sortBy: sortField)
        let request = NftsRequest(query: query)
        networkClient.send(request: request, type: [Nft].self) { [weak storage] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    storage?.saveNfts(nfts)
                    completion(.success(nfts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        let group = DispatchGroup()
        var nfts: [Nft] = []
        var unloadedNfts: [String] = []
        
        for id in ids {
            group.enter()
            
            loadNft(id: id) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    print("Failed to load NFT: \(error.localizedDescription)")
                    unloadedNfts.append(id)
                }
            }
        }
        
        group.notify(queue: .main) {
            if unloadedNfts.isEmpty {
                completion(.success(nfts))
            } else {
                completion(.failure(NftServiceError.failedToLoadNfts(unloadedNfts)))
            }
        }
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            DispatchQueue.main.async {
                completion(.success(nft))
            }
            return
        }

        let request = NftRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    storage?.saveNft(nft)
                    completion(.success(nft))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

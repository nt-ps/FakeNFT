import Foundation

typealias NftsCompletion = (Result<[Nft], Error>) -> Void
typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    func loadNfts(
        sortBy sortField: NftFields?,
        completion: @escaping NftsCompletion
    )
    
    func loadNft(id: String, completion: @escaping NftCompletion)
}

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
        let query = NftsQuery(sortBy: sortField)
        let request = NftsRequest(query: query)
        networkClient.send(request: request, type: [Nft].self) { [weak storage] result in
            switch result {
            case .success(let nfts):
                storage?.saveNfts(nfts)
                completion(.success(nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NftRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
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

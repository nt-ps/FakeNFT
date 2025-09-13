final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let collectionStorage: CollectionStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        collectionStorage: CollectionStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.collectionStorage = collectionStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var collectionService: CollectionServiceProtocol {
        CollectionService(
            networkClient: networkClient,
            storage: collectionStorage
        )
    }
}

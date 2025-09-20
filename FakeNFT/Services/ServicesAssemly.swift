final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let collectionStorage: CollectionStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        collectionStorage: CollectionStorageProtocol
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
        
    var userService: UserServiceProtocol {
        UserService(networkClient: networkClient)
    }
    
    var orderService: OrderServiceProtocol {
        OrderServiceImplementation()
    }
    
    var currenciesService: CurrenciesServiceProtocol {
        CurrenciesService()
    }
    
    var paymentService: PaymentServiceProtocol {
        PaymentService()
    }
    
    var profileService: ProfileServiceProtocol {
        ProfileService.shared
    }
    
    var profileStorage: ProfileStorage {
        ProfileStorage.shared
    }
}

import Foundation

// MARK: - Protocol

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get set }
    var nftDetailAssembler: NftDetailAssembly { get }
    
    var headerModel: CollectionHeaderModel? { get }
    var title: String? { get }
    
    func viewDidLoad()
    func switchLike(for nftIndex: Int)
    func switchStateInCart(for nftIndex: Int)
}

// MARK: - Implementation

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Internal Properties
    
    weak var view: CollectionViewControllerProtocol?
    
    let nftDetailAssembler: NftDetailAssembly
    
    // MARK: - Private Properties
    
    private(set) var headerModel: CollectionHeaderModel?
    let title: String?
    
    private let nftIds: [String]
    
    private let nftService: NftService
    private let userService: UserServiceProtocol?
    private let orderService: OrderServiceProtocol
    private let putOrderService: PutNewOrderServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let profileStorage: ProfileStorage
    
    private var nftModels: [NftCellModel] = []
    private var cart: [String] = []
    private var likes: [String] = []
    
    // MARK: - Initializers
    
    init(
        for collection: Collection,
        servicesAssembler: ServicesAssembly
    ) {
        self.headerModel = CollectionHeaderModel(
            name: collection.name,
            cover: collection.cover,
            description: collection.description,
            authorId: collection.author,
            authorName: collection.author
        )
        self.title = nil
        self.nftIds = collection.nfts
        
        self.nftService = servicesAssembler.nftService
        self.userService = servicesAssembler.userService
        self.orderService = servicesAssembler.orderService
        self.putOrderService = servicesAssembler.putOrderService
        self.profileService = servicesAssembler.profileService
        self.profileStorage = servicesAssembler.profileStorage
        
        self.nftDetailAssembler = NftDetailAssembly(nftService: nftService)
    }
    
    init(
        for nftIds: [String],
        title: String,
        servicesAssembler: ServicesAssembly
    ) {
        self.headerModel = nil
        self.title = title
        self.nftIds = nftIds
        
        self.nftService = servicesAssembler.nftService
        self.userService = servicesAssembler.userService
        self.orderService = servicesAssembler.orderService
        self.putOrderService = servicesAssembler.putOrderService
        self.profileService = servicesAssembler.profileService
        self.profileStorage = servicesAssembler.profileStorage
        
        self.nftDetailAssembler = NftDetailAssembly(nftService: nftService)
    }
    
    // MARK: - Internal Methods
    
    func viewDidLoad() {
        view?.showLoading()

        let dispatchGroup = DispatchGroup()
        loadNfts(dispatchGroup: dispatchGroup)
        loadOrder(dispatchGroup: dispatchGroup)
        loadLikes(dispatchGroup: dispatchGroup)
        if headerModel != nil {
            loadAuthor(dispatchGroup: dispatchGroup)
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.view?.updateCollectionViewAnimated(from: self.nftModels)
            self.updateCellButtons()
            self.view?.hideLoading()
        }
    }
    
    // TODO: После слияния актуализировать этот метод относительно сервиса Амины.
    func switchLike(for nftIndex: Int) {
        view?.showLoading()

        let nftId = nftModels[nftIndex].id
        var newLikes = likes
        var newLike = false;
        if let index = newLikes.firstIndex(of: nftId) {
            newLikes.remove(at: index)
        } else {
            newLikes.append(nftId)
            newLike = true
        }
        
        profileService.sendLikeRequest(likes: newLikes) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.likes = newLikes
                self.view?.setLike(newLike, for: nftIndex)
            case .failure(let error):
                print("[\(#function)] Failed to set like: \(error.localizedDescription).")
                let errorModel = ErrorModel(
                    title: L10n.Error.data,
                    message: nil,
                    actionText: nil,
                    action: nil
                )
                self.view?.showError(errorModel)
            }
            
            view?.hideLoading()
        }
    }
    
    // TODO: После слияния актуализировать этот метод относительно сервиса Вани.
    func switchStateInCart(for nftIndex: Int) {
        view?.showLoading()
        
        let nftId = nftModels[nftIndex].id
        var newCart = cart
        var newState = false
        if let index = newCart.firstIndex(of: nftId) {
            newCart.remove(at: index)
            newState = false
        } else {
            newCart.append(nftId)
            newState = true
        }
        
        putOrderService.postNewOrder(with: newCart) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.cart = newCart
                self.view?.setStateInCart(newState, for: nftIndex)
            case .failure(let error):
                print("[\(#function)] Failed to load order: \(error.localizedDescription).")
                let errorModel = ErrorModel(
                    title: L10n.Error.data,
                    message: nil,
                    actionText: nil,
                    action: nil
                )
                self.view?.showError(errorModel)
            }
            
            view?.hideLoading()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateCellButtons() {
        nftModels.indices.forEach { i in
            view?.setStateInCart(cart.contains(nftModels[i].id), for: i)
            view?.setLike(likes.contains(nftModels[i].id), for: i)
        }
    }
    
    private func loadNfts(dispatchGroup: DispatchGroup?) {
        dispatchGroup?.enter()
        
        // Сервер в массиве NFT коллекции возвращает несколько
        // одинаковых ID. На практике такого не должно быть, из-за
        // этого страдает вся логика. Поэтому добавил эту строчку,
        // в которой вычищаются дубликаты.
        let uniqueNftIds = Array(Set(nftIds))
        
        nftService.loadNfts(ids: uniqueNftIds) { [weak self] result in
            defer { dispatchGroup?.leave() }
            guard let self else { return }
            switch result {
            case .success(let nfts):
                self.nftModels.removeAll()
                nfts.forEach { nft in
                    let nftModel = NftCellModel(
                        id: nft.id,
                        name: nft.name,
                        images: nft.images,
                        rating: nft.rating,
                        price: nft.price,
                        isLiked: false,
                        inCart: false
                    )
                    self.nftModels.append(nftModel)
                }
            case .failure(let error):
                print("[\(#function)] Failed to load NFT of collection: \(error.localizedDescription).")
                let errorModel = ErrorModel(
                    title: L10n.Error.data,
                    message: nil,
                    actionText: nil,
                    action: nil
                )
                self.view?.showError(errorModel)
            }
        }
    }
    
    // TODO: После слияния актуализировать этот метод относительно сервиса Вани.
    private func loadOrder(dispatchGroup: DispatchGroup?) {
        dispatchGroup?.enter()
        orderService.fetchOrder() { [weak self] result in
            defer { dispatchGroup?.leave() }
            guard let self else { return }
            switch result {
            case .success(let order):
                self.cart.removeAll()
                self.cart.append(contentsOf: order.nfts)
            case .failure(let error):
                print("[\(#function)] Failed to load order: \(error.localizedDescription).")
                let errorModel = ErrorModel(
                    title: L10n.Error.data,
                    message: nil,
                    actionText: nil,
                    action: nil
                )
                self.view?.showError(errorModel)
            }
        }
    }
    
    // TODO: После слияния актуализировать этот метод относительно сервиса Амины.
    //
    // Пока на всякий случай каждый раз при открытии экрана коллекции
    // загружаю актуальный профайл, потому что в кэше может лежать неактуальная версия.
    private func loadLikes(dispatchGroup: DispatchGroup?) {
        dispatchGroup?.enter()
        profileService.fetchProfile { [weak self] result in
            defer { dispatchGroup?.leave() }
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.likes.removeAll()
                self.likes.append(contentsOf: profile.likes)
                self.profileStorage.profile = profile
            case .failure(let error):
                print("[\(#function)] Failed to load profile: \(error.localizedDescription).")
                let errorModel = ErrorModel(
                    title: L10n.Error.data,
                    message: nil,
                    actionText: nil,
                    action: nil
                )
                
                self.view?.showError(errorModel)
            }
        }
    }

    private func loadAuthor(dispatchGroup: DispatchGroup?) {
        // Тут должен быть сервис загрузки пользователя по ID
        // для получения его сайта. Но поскольку GET Collection
        // возвращает имя автора, то в хэдер пишу только полученное
        // имя, а сайт вставляю дефолтный (кто-то где-то в ТЗ
        // увидел, что нужно ставить эту ссылку).
        headerModel?.authorWebsite = "https://practicum.yandex.ru/ios-developer"
    }
}

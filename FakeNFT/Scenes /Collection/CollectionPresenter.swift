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
    private let putOrederService: PutNewOrderServiceProtocol
    
    private var nftModels: [NftCellModel] = []
    private var cart: [String] = []
    
    // MARK: - Initializers
    
    init(
        for collection: Collection,
        nftService: NftService,
        userService: UserServiceProtocol,
        orderService: OrderServiceProtocol,
        putOrederService: PutNewOrderServiceProtocol
    ) {
        self.headerModel = CollectionHeaderModel(
            name: collection.name,
            cover: collection.cover,
            description: collection.description,
            authorId: collection.author
        )
        self.title = nil
        self.nftIds = collection.nfts
        self.nftService = nftService
        self.userService = userService
        self.orderService = orderService
        self.putOrederService = putOrederService
        self.nftDetailAssembler = NftDetailAssembly(nftService: nftService)
    }
    
    init(
        for nftIds: [String],
        title: String,
        nftService: NftService,
        orderService: OrderServiceProtocol,
        putOrederService: PutNewOrderServiceProtocol
    ) {
        self.headerModel = nil
        self.title = title
        self.nftIds = nftIds
        self.nftService = nftService
        self.userService = nil
        self.orderService = orderService
        self.putOrederService = putOrederService
        self.nftDetailAssembler = NftDetailAssembly(nftService: nftService)
    }
    
    // MARK: - Internal Methods
    
    func viewDidLoad() {
        view?.showLoading()

        let dispatchGroup = DispatchGroup()
        loadNfts(dispatchGroup: dispatchGroup)
        loadOrder(dispatchGroup: dispatchGroup)
        if headerModel != nil {
            loadAuthor(dispatchGroup: dispatchGroup)
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.view?.updateCollectionViewAnimated(from: self.nftModels)
            self.updateCartButtons()
            self.view?.hideLoading()
        }
    }
    
    func switchLike(for nftIndex: Int) {
        // TODO: Вызывать сервис профиля для установки лайка.
        // Помнить про показ лоадера и ошибки.

        view?.setLike(true, for: nftIndex)
    }
    
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
        
        putOrederService.postNewOrder(with: newCart) { [weak self] result in
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
    
    private func updateCartButtons() {
        nftModels.indices.forEach { i in
            view?.setStateInCart(cart.contains(nftModels[i].id), for: i)
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

    private func loadAuthor(dispatchGroup: DispatchGroup?) {
        dispatchGroup?.enter()
        
        userService?.loadUser(
            by: "77bd726b-15bc-4ad3-92c4-c4c97adb9491"/*headerModel?.authorName ?? ""*/
        ) { [weak self] result in
            defer { dispatchGroup?.leave() }
            guard let self else { return }
            switch result {
            case .success(let user):
                self.headerModel?.authorName = user.name
                self.headerModel?.authorWebsite = user.website
            case .failure(let error):
                print("[\(#function)] Failed to load user: \(error.localizedDescription).")
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
}

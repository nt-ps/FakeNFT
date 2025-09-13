import Foundation

// MARK: - Protocol

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get set }
    var nftDetailAssembler: NftDetailAssembly { get }
    var collection: Collection? { get }
    var title: String? { get }
    
    func loadNfts()
    func switchLike(for nftIndex: Int)
    func switchStateInCart(for nftIndex: Int)
}

// MARK: - Implementation

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Internal Properties
    
    weak var view: CollectionViewControllerProtocol?
    
    let nftDetailAssembler: NftDetailAssembly
    
    // MARK: - Private Properties
    
    let collection: Collection?
    let title: String?
    
    private let nftIds: [String]?
    
    private let nftService: NftService
    
    // MARK: - Initializers
    
    init(
        for collection: Collection,
        nftService: NftService
    ) {
        self.collection = collection
        self.title = nil
        self.nftIds = collection.nfts
        self.nftService = nftService
        self.nftDetailAssembler = NftDetailAssembly(nftService: nftService)
    }
    
    init(
        for nftIds: [String],
        title: String,
        nftService: NftService
    ) {
        self.collection = nil
        self.title = title
        self.nftIds = nftIds
        self.nftService = nftService
        self.nftDetailAssembler = NftDetailAssembly(nftService: nftService)
    }
    
    // MARK: - Internal Methods
    
    func loadNfts() {
        guard let nftIds else { return }
        
        // Сервер в массиве NFT коллекции возвращает несколько
        // одинаковых ID. На практике такого не должно быть, из-за
        // этого страдает вся логика. Поэтому добавил эту строчку,
        // в которой вычищаются дубликаты.
        let uniqueNftIds = Array(Set(nftIds))
        
        view?.showLoading()
        
        nftService.loadNfts(ids: uniqueNftIds) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.view?.updateCollectionViewAnimated(from: nfts)
            case .failure(let error):
                print("[\(#function)] Failed to load NFT of collection: \(error.localizedDescription).")
                
                let errorModel = ErrorModel(
                    title: L10n.Error.data,
                    message: nil,
                    actionText: L10n.Catalog.FailureAlert.repeat
                ) { [weak self] in self?.loadNfts() }
                
                self?.view?.showError(errorModel)
            }
            
            self?.view?.hideLoading()
        }
    }
    
    func switchLike(for nftIndex: Int) {
        // TODO: Вызывать сервис профиля для установки лайка.
        // Помнить про показ лоадера и ошибки.

        view?.setLike(true, for: nftIndex)
    }
    
    func switchStateInCart(for nftIndex: Int) {
        // TODO: Вызывать сервис заказа для добавления в корзину или удаления.
        // Помнить про показ лоадера и ошибки.
        
        view?.setStateInCart(true, for: nftIndex)
    }
}

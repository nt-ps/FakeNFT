import Foundation

// MARK: - Protocol

protocol CollectionPresenterProtocol { }

// MARK: - Implementation

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Internal Properties
    
    var view: CollectionViewControllerProtocol?
    
    // MARK: - Private Properties
    
    private var collection: Collection?
    private var nftIds: [UUID]?
    
    private let nftService: NftService
    
    // MARK: - Initializers
    
    init(
        for collection: Collection,
        nftService: NftService
    ) {
        self.collection = collection
        self.nftService = nftService
    }
    
    init(
        for nftIds: [UUID],
        nftService: NftService
    ) {
        self.nftIds = nftIds
        self.nftService = nftService
    }
    
    // MARK: - Internal Methods
    
    func viewDidLoad() {}
}

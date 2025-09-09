import Foundation

// MARK: - Protocol

protocol CollectionPresenterProtocol {
    var collection: Collection? { get }
    var title: String? { get }
    
    var view: CollectionViewControllerProtocol? { get set }
}

// MARK: - Implementation

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Internal Properties
    
    weak var view: CollectionViewControllerProtocol?
    
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
    }
    
    // MARK: - Internal Methods
    
    func viewDidLoad() {}
}

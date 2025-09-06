import UIKit

protocol CollectionViewAssemblyProtocol {
    func build(with collection: Collection) -> UIViewController
}

final class CollectionViewAssembly: CollectionViewAssemblyProtocol {
    
    // MARK: - Internal Properties
    
    let servicesAssembler: ServicesAssembly
    
    // MARK: - Initializers
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    // MARK: - Internal Properties
    
    // Экран Collection.
    func build(with collection: Collection) -> UIViewController {
        let presenter = CollectionPresenter(
            for: collection,
            nftService: servicesAssembler.nftService
        )
        let layout = UICollectionViewFlowLayout()
        let viewController = CollectionViewController(
            presenter: presenter,
            collectionViewLayout: layout
        )
        presenter.view = viewController
        return viewController
    }
    
    // Экран Users collection.
    func build(with nftIds: [UUID]) -> UIViewController {
        let presenter = CollectionPresenter(
            for: nftIds,
            nftService: servicesAssembler.nftService
        )
        let layout = UICollectionViewFlowLayout()
        let viewController = CollectionViewController(
            presenter: presenter,
            collectionViewLayout: layout
        )
        presenter.view = viewController
        return viewController
    }
}

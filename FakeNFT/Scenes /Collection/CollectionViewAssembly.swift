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
    
    func build(with collection: Collection) -> UIViewController {
        let presenter = CollectionPresenter(
            for: collection,
            nftService: servicesAssembler.nftService
        )
        let viewController = CollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}


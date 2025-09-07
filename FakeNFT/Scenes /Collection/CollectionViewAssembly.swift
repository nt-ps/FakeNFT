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
        var presenter: CollectionPresenterProtocol = CollectionPresenter(
            for: collection,
            nftService: servicesAssembler.nftService
        )
        let viewController = build(with: &presenter)
        return viewController
    }
    
    // Экран Users collection.
    func build(with nftIds: [UUID]) -> UIViewController {
        var presenter: CollectionPresenterProtocol = CollectionPresenter(
            for: nftIds,
            nftService: servicesAssembler.nftService
        )
        let viewController = build(with: &presenter)
        return viewController
    }
    
    private func build(with presenter: inout CollectionPresenterProtocol) -> UIViewController {
        let viewController = CollectionViewController(presenter: presenter)
        viewController.hidesBottomBarWhenPushed = true
        presenter.view = viewController
        return viewController
    }
}

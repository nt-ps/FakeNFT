import Foundation

protocol CataloguePresenterProtocol {
    var view: CatalogueViewControllerProtocol? { get set }
    
    func fetchNextPage()
    func sort(by field: CollectionFields) -> Bool
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    weak var view: CatalogueViewControllerProtocol?
    
    private let collectionService: CollectionServiceProtocol
    
    init(servicesAssembly: ServicesAssembly) {
        self.collectionService = servicesAssembly.collectionService
    }
    
    func fetchNextPage() {
        collectionService.fetchNextPage() { [weak self] result in
            switch result {
            case .success(let collections):
                self?.view?.updateTableViewAnimated(from: collections)
            case .failure:
                print("[\(#function)] Failed to load collection page.")
                // TODO: При протягивании сетевого слоя добавить вывод алерта.
            }
        }
    }
    
    func sort(by field: CollectionFields) -> Bool {
        collectionService.sort(by: field)
    }
}

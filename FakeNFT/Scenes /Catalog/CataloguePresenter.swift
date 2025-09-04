import Foundation

// MARK: - Protocol

protocol CataloguePresenterProtocol {
    var view: CatalogueViewControllerProtocol? { get set }
    var collectionViewAssembler: CollectionViewAssemblyProtocol { get }
    
    func fetchNextPage()
    func sort(by field: CollectionFields) -> Bool
}

// MARK: - Implementation

final class CataloguePresenter: CataloguePresenterProtocol {
    
    weak var view: CatalogueViewControllerProtocol?
    
    let collectionViewAssembler: CollectionViewAssemblyProtocol
    
    private let collectionService: CollectionServiceProtocol
    
    init(servicesAssembler: ServicesAssembly) {
        self.collectionViewAssembler = CollectionViewAssembly(
            servicesAssembler: servicesAssembler
        )
        self.collectionService = servicesAssembler.collectionService
    }
    
    func fetchNextPage() {
        collectionService.fetchNextPage() { [weak self] result in
            switch result {
            case .success(let collections):
                guard let self else { return }
                self.view?.updateTableViewAnimated(from: collections)
            case .failure:
                print("[\(#function)] Failed to load collection page.")
                // TODO: При протягивании сети добавить вывод алерта.
            }
        }
    }
    
    func sort(by field: CollectionFields) -> Bool {
        collectionService.sort(by: field)
    }
}

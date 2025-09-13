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
    
    private var localStorage: LocalStorageProtocol
    private let collectionService: CollectionServiceProtocol
    
    init(
        localStorage: LocalStorageProtocol,
        servicesAssembler: ServicesAssembly
    ) {
        self.localStorage = localStorage
        
        self.collectionViewAssembler = CollectionViewAssembly(
            servicesAssembler: servicesAssembler
        )
        self.collectionService = servicesAssembler.collectionService

        _ = self.sort(by: localStorage.collectionSortField)
    }
    
    func fetchNextPage() {        
        let inProcessing = collectionService.fetchNextPage() { [weak self] result in
            switch result {
            case .success(let collections):
                self?.view?.updateTableViewAnimated(from: collections)
            case .failure(let error):
                print("[\(#function)] Failed to load collection page: \(error.localizedDescription).")
                
                let errorModel = ErrorModel(
                    title: L10n.Catalog.FailureAlert.title,
                    message: nil,
                    actionText: L10n.Catalog.FailureAlert.repeat
                ) { [weak self] in self?.fetchNextPage() }
                
                self?.view?.showError(errorModel)
            }
            
            self?.view?.hideLoading()
        }
        
        if inProcessing {
            view?.showLoading()
        }
    }
    
    func sort(by field: CollectionFields) -> Bool {
        if collectionService.sort(by: field) {
            localStorage.collectionSortField = field
            return true
        }
        
        return false
    }
}

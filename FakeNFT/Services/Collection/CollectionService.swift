import Foundation

typealias CollectionCompletion = (Result<Collection, Error>) -> Void
typealias CollectionsCompletion = (Result<[Collection], Error>) -> Void

// MARK: - Protocol

protocol CollectionServiceProtocol {
    func loadBy(id: String, completion: @escaping CollectionCompletion) -> Bool
    func fetchNextPage(completion: @escaping CollectionsCompletion) -> Bool
    func sort(by field: CollectionFields) -> Bool
}

// MARK: - Implementation

final class CollectionService: CollectionServiceProtocol {
    
    // MARK: - Private Properties
    
    private let networkClient: NetworkClient
    private let storage: CollectionStorage
    
    private var collections: [Collection] = []
    private var isListComplete = false
    
    private var sortField: CollectionFields = .name
    
    private let pageSize: Int = 5
    private var lastLoadedPage: Int = -1
    
    private var task: NetworkTask?
    
    // MARK: - Initializers

    init(networkClient: NetworkClient, storage: CollectionStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    // MARK: - Collection Service Protocol Methods
    
    func loadBy(id: String, completion: @escaping CollectionCompletion) -> Bool {
        if task != nil {
            return false
        }
        
        if let collection = storage.get(by: id) {
            DispatchQueue.main.async { completion(.success(collection)) }
            return true
        }

        let request = CollectionRequest(id: id)
        task = networkClient.send(
            request: request,
            type: Collection.self
        ) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let collection):
                    self.storage.save(collection: collection)
                    completion(.success(collection))
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self.task = nil
            }
        }
        
        return true
    }
    
    func fetchNextPage(completion: @escaping CollectionsCompletion) -> Bool {
        if task != nil || isListComplete {
            return false
        }
        
        let currentPageNumber = lastLoadedPage + 1
        
        let query = CollectionsApiQuery(
            sortBy: sortField,
            pagination: Pagination(page: currentPageNumber, size: pageSize)
        )
        let request = CollectionsRequest(query: query)
        
        task = networkClient.send(
            request: request,
            type: [Collection].self
        ) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let page):
                    if page.isEmpty {
                        self.isListComplete = true
                    }
                    self.collections.append(contentsOf: page)
                    self.storage.save(collections: page)
                    self.lastLoadedPage = currentPageNumber
                    
                    completion(.success(self.collections))
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self.task = nil
            }
        }
        
        return true
    }
    
    func sort(by field: CollectionFields) -> Bool {
        if task == nil, sortField != field {
            sortField = field
            collections.removeAll()
            isListComplete = false
            lastLoadedPage = -1
            return true
        }
        
        return false
    }
}

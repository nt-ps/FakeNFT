import Foundation

final class CollectionMockService: CollectionServiceProtocol {

    var sortField: CollectionFields = .name {
        didSet {
            collections.removeAll()
            lastLoadedPage = 0
        }
    }
    
    private var collections: [Collection] = []
    
    private let pageSize: Int = 6
    private var lastLoadedPage: Int = 0
    private var maxPageNum: Int = 2

    func fetchNextPage(completion: @escaping CollectionsCompletion) {
        guard lastLoadedPage < maxPageNum else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                completion(.success(self.collections))
            }
            return
        }
        
        let page = MockData.getPage(sortBy: sortField, num: lastLoadedPage, size: pageSize)
        
        lastLoadedPage += 1
        
        collections.append(contentsOf: page)

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            completion(.success(self.collections))
        }
    }
}

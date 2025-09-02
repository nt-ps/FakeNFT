import Foundation

//final class CollectionMockService: CollectionServiceProtocol {
//    private var collections: [Collection] = []
//    private var sortField: CollectionFields = .name
//    
//    private let pageSize: Int = 6
//    private var lastLoadedPage: Int = 0
//    private var maxPageNum: Int = 2
//
//    func fetchNextPage(completion: @escaping CollectionsCompletion) {
//        guard lastLoadedPage < maxPageNum else {
//            DispatchQueue.main.async { [weak self] in
//                guard let self else { return }
//                completion(.success(self.collections))
//            }
//            return
//        }
//        
//        let page = MockData.getPage(sortBy: sortField, num: lastLoadedPage, size: pageSize)
//        
//        lastLoadedPage += 1
//        
//        collections.append(contentsOf: page)
//
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
//            completion(.success(self.collections))
//        }
//    }
//    
//    func sort(by field: CollectionFields) -> Bool {
//        if sortField != field {
//            sortField = field
//            collections.removeAll()
//            lastLoadedPage = 0
//            return true
//        }
//        
//        return false
//    }
//}

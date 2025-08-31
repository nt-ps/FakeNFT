import Foundation

typealias CollectionsCompletion = (Result<[Collection], Error>) -> Void

protocol CollectionServiceProtocol {
    var sortField: CollectionFields { get set }
    
    func fetchNextPage(completion: @escaping CollectionsCompletion)
}

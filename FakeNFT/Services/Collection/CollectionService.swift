import Foundation

typealias CollectionsCompletion = (Result<[Collection], Error>) -> Void

protocol CollectionServiceProtocol {
    func fetchNextPage(completion: @escaping CollectionsCompletion)
    func sort(by field: CollectionFields) -> Bool
}

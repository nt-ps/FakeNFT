import Foundation

// MARK: - Protocol

protocol CollectionStorageProtocol {
    func save(collection: Collection)
    func save(collections: [Collection])
    func get(by id: String) -> Collection?
}

// MARK: - Implementation

final class CollectionStorage: CollectionStorageProtocol {
    
    private var storage: [String: Collection] = [:]

    private let syncQueue = DispatchQueue(label: "sync-collection-queue")
    
    func save(collection: Collection) {
        syncQueue.async { [weak self] in
            self?.storage[collection.id] = collection
        }
    }
    
    func save(collections: [Collection]) {
        collections.forEach { save(collection: $0) }
    }
    
    func get(by id: String) -> Collection? {
        syncQueue.sync {
            storage[id]
        }
    }
}

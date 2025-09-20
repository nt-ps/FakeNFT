// TODO: Поговорить с командой об использовании этого сервиса
// для ценрализованной записи и чтения данных из UserDefaults
// (на данный момент все суют UserDefaults куда попало).

import Foundation

// MARK: - Protocol

protocol LocalStorageProtocol {
    var collectionSortField: CollectionFields { get set }
}

// MARK: - Implementation

final class UserDefaultsStorage: LocalStorageProtocol {
    
    static let shared = UserDefaultsStorage()

    var collectionSortField: CollectionFields {
        get {
            guard
                let stringValue = storage.string(
                    forKey: Keys.collectionSortField.rawValue
                ),
                let value = CollectionFields(rawValue: stringValue)
            else { return defaultCollectionSortField }
            
            return value
        }
        set {
            storage.set(
                newValue.rawValue,
                forKey: Keys.collectionSortField.rawValue
            )
        }
    }
    
    private let defaultCollectionSortField: CollectionFields = .name
    
    
    
    private enum Keys: String {
        case collectionSortField
    }
    
    private let storage: UserDefaults = .standard
    
    private init() { }
}

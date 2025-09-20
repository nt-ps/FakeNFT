import Foundation

// MARK: - Protocol

protocol LocalStorageProtocol {
    var onboardingCompleted: Bool { get set }
    var shoppingCartSortMethod: String { get set }
    var statisticsSortType: StatisticsSortType { get set }
    var collectionSortField: CollectionFields { get set }
}

// MARK: - Implementation

final class UserDefaultsStorage: LocalStorageProtocol {
    
    // MARK: - Onboarding
    
    var onboardingCompleted: Bool {
        get { storage.bool(forKey: Keys.onboardingCompleted.rawValue) }
        set { storage.set(newValue, forKey: Keys.onboardingCompleted.rawValue) }
    }

    // MARK: - Shopping Cart
    
    var shoppingCartSortMethod: String {
        get {
            storage.string(
                forKey: Keys.shoppingCartSortMethod.rawValue
            ) ?? defaultShoppingCartSortMethod
        }
        set {
            storage.set(
                newValue,
                forKey: Keys.shoppingCartSortMethod.rawValue
            )
        }
    }
    
    private let defaultShoppingCartSortMethod: String = L10n.SortAlert.byName
    
    // MARK: - Statistics
    
    var statisticsSortType: StatisticsSortType {
        get {
            guard
                let stringValue = storage.string(
                    forKey: Keys.statisticsSortType.rawValue
                ),
                let value = StatisticsSortType(rawValue: stringValue)
            else { return defaultStatisticsSortType }
            
            return value
        }
        set {
            storage.set(
                newValue.rawValue,
                forKey: Keys.statisticsSortType.rawValue
            )
        }
    }
    
    private let defaultStatisticsSortType: StatisticsSortType = .rating
    
    // MARK: - Collection
    
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
    
    // MARK: - Private Components
    
    private enum Keys: String {
        case onboardingCompleted,
             shoppingCartSortMethod,
             statisticsSortType,
             collectionSortField
    }
    
    private let storage: UserDefaults = .standard
}

import Foundation

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewController? { get set }
    func sortByName()
    func sortByRating()
    func viewDidLoad()
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    private let servicesAssembly: ServicesAssembly
    weak var view: StatisticsViewController?
    
    private var mockUsers: [User] = [
           User(id: 1, name: "Bill", username: "@bill", nftCount: 2, avatarURL: nil),
           User(id: 2, name: "Alla", username: "@alla", nftCount: 4, avatarURL: nil),
           User(id: 3, name: "Mads", username: "@mads", nftCount: 6, avatarURL: nil),
           User(id: 4, name: "Timothée", username: "@timothee", nftCount: 8, avatarURL: nil),
           User(id: 5, name: "Lea", username: "@lea", nftCount: 9, avatarURL: nil),
           User(id: 6, name: "Eric", username: "@eric", nftCount: 11, avatarURL: nil)
       ]

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func viewDidLoad() {
        sortByRating()
    }
    
    func sortByName() {
        mockUsers.sort { $0.name < $1.name }
        view?.usersDidUpdated(mockUsers)
    }
    
    func sortByRating() {
        mockUsers.sort { $0.nftCount > $1.nftCount }
        view?.usersDidUpdated(mockUsers)
    }
}

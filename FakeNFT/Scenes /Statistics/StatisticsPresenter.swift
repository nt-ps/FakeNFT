import Foundation

protocol StatisticsPresenterProtocol {
    var view: StatisticsViewController? { get set }
    func sortByName()
    func sortByRating()
    func viewDidLoad()
    func loadMoreUsers()
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    private let servicesAssembly: ServicesAssembly
    weak var view: StatisticsViewController?
    
    private var users: [User] = []
    private var isLoading = false
    private var currentSortIsRating = true
    private var currentPage = 0
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func viewDidLoad() {
        loadUsers()
    }
    
    func sortByName() {
        currentSortIsRating = false
        users.sort { $0.name < $1.name }
        view?.usersDidUpdated(users)
    }
    
    func sortByRating() {
        currentSortIsRating = true
        users.sort { $0.rating > $1.rating }
        view?.usersDidUpdated(users)
    }
    
    func loadMoreUsers() {
        guard !isLoading, currentPage != 10 else {
            print("Попытка загрузки более 10 страниц")
            return
        }
        currentPage += 1
        loadUsers()
    }
    
    private func loadUsers() {
        guard !isLoading else { return }
        isLoading = true
        
        servicesAssembly.userService.loadUsers(page: currentPage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let users):
                print("Успешная загрузка \(users.count) пользователей")
                self.users.isEmpty ? self.users = users : self.users.append(contentsOf: users)
                self.currentSortIsRating ? sortByRating() : sortByName()
            case .failure(let error):
                if self.currentPage > 0 {
                    self.currentPage -= 1
                }
                print("Ошибка загрузки:\(error)")
            }
            self.isLoading = false
        }
    }
}

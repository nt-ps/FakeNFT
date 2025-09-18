import Foundation


protocol UserProfilePresenterProtocol: AnyObject {
    var view: UsersProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTappedUserWebsite()
    func didTappedUserCollection()
}

final class UsersProfilePresenter: UserProfilePresenterProtocol {
    weak var view: UsersProfileViewControllerProtocol?
    private var user: User?
    private let servicesAssembly: ServicesAssembly
    
    init(user: User?, servicesAssembly: ServicesAssembly) {
        self.user = user
        self.servicesAssembly = servicesAssembly
    }
    
    func viewDidLoad() {
        guard let user else { return }
        view?.configure(with: user)
    }
    
    func didTappedUserWebsite() {
        guard let user,
              let urlString = user.website,
              let url = URL(string: urlString) else {
            print("Некорректный URL сайта")
            return
        }
        let urlRequest = URLRequest(url: url)
        let viewController = WebViewAssembly().build(with: urlRequest)
        
        view?.navigateToViewController(viewController: viewController)
    }
    
    func didTappedUserCollection() {
        guard let user else { return }
        
        let viewController = CollectionViewAssembly(servicesAssembler: servicesAssembly).build(with: user.nfts, title: "Коллекция NFT")
        
        view?.navigateToViewController(viewController: viewController)
    }
}

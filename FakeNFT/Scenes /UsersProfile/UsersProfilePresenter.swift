import Foundation


protocol UserProfilePresenterProtocol: AnyObject {
    var view: UsersProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTappedUserWebsite()
}

final class UsersProfilePresenter: UserProfilePresenterProtocol {
    weak var view: UsersProfileViewControllerProtocol?
    private var user: User?
    
    init(user: User?) {
        self.user = user
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
        var viewController = WebViewAssembly().build(with: urlRequest)
        
        view?.navigateToViewController(viewController: viewController)
    }
}

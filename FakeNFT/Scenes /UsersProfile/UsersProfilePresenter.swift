import UIKit


protocol UserProfilePresenterProtocol: AnyObject {
    var view: UsersProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapUserWebsite(onNavigate: (UIViewController) -> Void)
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
    
    func didTapUserWebsite(onNavigate: (UIViewController) -> Void) {
        guard let user,
              let urlString = user.website,
              let url = URL(string: urlString) else {
            print("Некорректный URL сайта")
            return
        }
        let urlRequest = URLRequest(url: url)
        let viewController = WebViewAssembly().build(with: urlRequest)
        onNavigate(viewController)
    }
}

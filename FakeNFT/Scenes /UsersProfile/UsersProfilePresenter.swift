import Foundation


protocol UserProfilePresenterProtocol {
    var view: UsersProfileViewController? { get set }
}

final class UsersProfilePresenter: UserProfilePresenterProtocol {
    weak var view: UsersProfileViewController?
    private var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    func viewDidLoad() {
    }
}

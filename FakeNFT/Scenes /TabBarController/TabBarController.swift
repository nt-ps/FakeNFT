import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    private let shoppingCartTabBarItem = UITabBarItem(
        title: L10n.Tab.cart,
        image: .Icons.cartTab,
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let shoppingCartNavigationController = configureShoppingCart()
        
        viewControllers = [catalogController, shoppingCartNavigationController]

        view.backgroundColor = .systemBackground
    }
    
    private func configureShoppingCart() -> UIViewController {
        let shoppingCartModel = ShoppingCartModelImplementation(servicesAssembly: servicesAssembly)
        let shoppingCartViewController = ShoppingCartViewControllerImplementation()
        let shoppingCartPresenter = ShoppingCartPresenterImplementation(shoppingCartView: shoppingCartViewController, shoppingCartModel: shoppingCartModel)
        shoppingCartViewController.shoppingCartPresenter = shoppingCartPresenter
        shoppingCartModel.shoppingCartPresenter = shoppingCartPresenter
        shoppingCartViewController.tabBarItem = shoppingCartTabBarItem
        return UINavigationController(rootViewController: shoppingCartViewController)
    }
}

import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(resource: .Icons.catalogTab),
        tag: 0
    )
    
    // TODO: Удалить после добавления всех вкладок.
    private let testCatalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: L10n.Tab.statistics,
        image: UIImage(resource: .Icons.statisticTab),
        tag: 3
    )
    
    private var profileNavigationController: UINavigationController {
        let navigationController = ProfileNavigationController()
        
        navigationController.tabBarItem = UITabBarItem(
            title: L10n.Tab.profile,
            image: .Icons.profileTab,
            selectedImage: nil
        )
        
        return navigationController
    }
    
    private let shoppingCartTabBarItem = UITabBarItem(title: L10n.Tab.cart, image: .Icons.cartTab, tag: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .AppColors.black
        
        let catalogueController = CatalogueNavigationController(
            servicesAssembly: servicesAssembly
        )
        catalogueController.tabBarItem = catalogTabBarItem

        let shoppingCartNavigationController = configureShoppingCart()
        
        viewControllers = [catalogueController, shoppingCartNavigationController]
        
        catalogueController.tabBarItem = catalogTabBarItem
        
        // TODO: Удалить после добавления всех вкладок.
        let testCatalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        testCatalogController.tabBarItem = testCatalogTabBarItem

 //       viewControllers = [
 //           catalogueController,
 //           testCatalogController // TODO: Удалить!
 //       ]

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

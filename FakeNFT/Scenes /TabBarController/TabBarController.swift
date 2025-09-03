import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogueTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(resource: .Icons.catalogTab),
        tag: 0
    )
    
    private let shoppingCartTabBarItem = UITabBarItem(title: L10n.Tab.cart, image: .Icons.cartTab, tag: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .AppColors.white
        appearance.stackedLayoutAppearance.normal.iconColor = .AppColors.black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.AppColors.black
        ]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .AppColors.Universal.blue
        
        let catalogueController = CatalogueNavigationController(
            servicesAssembly: servicesAssembly
        )
        catalogueController.tabBarItem = catalogueTabBarItem

        let shoppingCartNavigationController = configureShoppingCart()
        
        viewControllers = [catalogueController, shoppingCartNavigationController]
        
        // TODO: Удалить после добавления всех вкладок.
        let testCatalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )

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

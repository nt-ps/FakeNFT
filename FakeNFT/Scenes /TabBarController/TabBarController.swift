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
        catalogueController.tabBarItem = catalogTabBarItem
        
        // TODO: Удалить после добавления всех вкладок.
        let testCatalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        testCatalogController.tabBarItem = testCatalogTabBarItem

        viewControllers = [
            catalogueController,
            testCatalogController // TODO: Удалить!
        ]

        view.backgroundColor = .systemBackground
    }
}

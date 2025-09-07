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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .AppColors.black
        
        let catalogueController = CatalogueNavigationController(
            servicesAssembly: servicesAssembly
        )
        catalogueController.tabBarItem = catalogTabBarItem
        
        // TODO: Удалить после добавления всех вкладок.
        let testCatalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        testCatalogController.tabBarItem = testCatalogTabBarItem

        
        let statisticsPresenter = StatisticsPresenter(servicesAssembly: servicesAssembly)
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        
       
        
        viewControllers = [catalogueController, testCatalogController, statisticsNavigationController]
        
        view.backgroundColor = .systemBackground
    }
}

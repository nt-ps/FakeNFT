import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(resource: .Icons.catalogTab),
        tag: 0
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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .AppColors.black
        
        let catalogueController = CatalogueNavigationController(
            servicesAssembly: servicesAssembly
        )
      
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController, profileNavigationController]
        
        let statisticsPresenter = StatisticsPresenter(servicesAssembly: servicesAssembly)
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        
       
        
        viewControllers = [catalogueController, testCatalogController, statisticsNavigationController]
        
        view.backgroundColor = .systemBackground
    }
}

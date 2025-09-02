import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: L10n.Tab.statistics,
        image: UIImage(resource: .Icons.statisticTab),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let statisticsPresenter = StatisticsPresenter(servicesAssembly: servicesAssembly)
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController, statisticsNavigationController]

        view.backgroundColor = .systemBackground
    }
}

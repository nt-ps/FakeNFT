import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(systemName: "square.stack.3d.up.fill"),
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

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController, profileNavigationController]

        view.backgroundColor = .systemBackground
    }
}

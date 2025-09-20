import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly!
    var localStorage: LocalStorageProtocol!

    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: UIImage(resource: .Icons.catalogTab),
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
            tag: 0
        )
        
        return navigationController
    }
    
    private let shoppingCartTabBarItem = UITabBarItem(
        title: L10n.Tab.cart,
        image: .Icons.cartTab,
        tag: 2
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
            servicesAssembly: servicesAssembly,
            localStorage: localStorage
        )
        catalogueController.tabBarItem = catalogTabBarItem
        
        let statisticsPresenter = StatisticsPresenter(
            servicesAssembly: servicesAssembly,
            localStorage: localStorage
        )
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        
        statisticsNavigationController.tabBarItem = statisticsTabBarItem
        
        let shoppingCartNavigationController = configureShoppingCart()
        
        viewControllers = [profileNavigationController, catalogueController, shoppingCartNavigationController, statisticsNavigationController]
        
        selectedViewController = catalogueController
        
        view.backgroundColor = .systemBackground
        checkOnboardingStatus()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    private func checkOnboardingStatus() {
        if !localStorage.onboardingCompleted {
            showOnboarding()
        }
    }
    
    private func showOnboarding() {
        let onboardingVC = OnboardingPage(localStorage: localStorage)
        onboardingVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(onboardingVC, animated: true)
        }
    }
    
    private func configureShoppingCart() -> UIViewController {
        let shoppingCartModel = ShoppingCartModelImplementation(
            servicesAssembler: servicesAssembly,
            localStorage: localStorage
        )
        let shoppingCartViewController = ShoppingCartViewControllerImplementation()
        let shoppingCartPresenter = ShoppingCartPresenterImplementation(
            shoppingCartView: shoppingCartViewController,
            shoppingCartModel: shoppingCartModel,
            servicesAssembler: servicesAssembly
        )
        shoppingCartViewController.shoppingCartPresenter = shoppingCartPresenter
        shoppingCartModel.shoppingCartPresenter = shoppingCartPresenter
        shoppingCartViewController.tabBarItem = shoppingCartTabBarItem
        return UINavigationController(rootViewController: shoppingCartViewController)
    }
}


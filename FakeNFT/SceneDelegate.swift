import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        collectionStorage: CollectionStorage()
    )
    
    let localStorage = UserDefaultsStorage()

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        configureNavigationBar()
        
        let tabBarController = window?.rootViewController as? TabBarController
        tabBarController?.servicesAssembly = servicesAssembly
        tabBarController?.localStorage = localStorage
    }
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .AppColors.black
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.clear],
            for: .normal
        )
        barButtonItemAppearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.clear],
            for: .highlighted
        )
        barButtonItemAppearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.clear],
            for: .disabled
        )
        barButtonItemAppearance.setTitleTextAttributes(
            [.foregroundColor: UIColor.clear],
            for: .focused
        )
    }
}

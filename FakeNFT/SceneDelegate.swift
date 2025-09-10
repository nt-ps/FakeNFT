import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        UINavigationBar.appearance().tintColor = .AppColors.black
        UIBarButtonItem.appearance().setTitleTextAttributes(
                [.foregroundColor: UIColor.clear],
                for: .normal
            )
        
        let tabBarController = window?.rootViewController as? TabBarController
        tabBarController?.servicesAssembly = servicesAssembly
    }
}

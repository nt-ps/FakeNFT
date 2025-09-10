import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard UserDefaults.standard.bool(forKey: "isItFirstLaunch") == false
        else {
            UserDefaults.standard.set(L10n.SortAlert.byName, forKey: "chosenSortMethod")
            UserDefaults.standard.set(false, forKey: "isItFirstLaunch")
            return true
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

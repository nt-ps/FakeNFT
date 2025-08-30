import UIKit

final class WebViewAssembly {
    func build(with request: URLRequest) -> UIViewController {
        let presenter = WebViewPresenter(for: request)
        let viewController = WebViewViewController()
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}

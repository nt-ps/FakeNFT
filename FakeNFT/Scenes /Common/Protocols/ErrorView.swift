import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let alertModel = AlertModel(
            title: L10n.Error.title,
            message: model.message,
            buttons: [
                AlertButton(text: model.actionText, action: model.action)
            ]
        )
        AlertPresenter.present(in: self, model: alertModel)
    }
}

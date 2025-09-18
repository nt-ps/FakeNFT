import UIKit

struct ErrorModel {
    let title: String?
    let message: String?
    let actionText: (String)?
    let action: (() -> Void)?
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        // Заметка: В модель добавлено поле title,
        // поскольку окна с ошибками отличаются заголовками.
        // let title = L10n.Error.title
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        if let actionText = model.actionText {
            let action = UIAlertAction(title: actionText, style: UIAlertAction.Style.default) {_ in
                model.action?()
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: L10n.Error.cancel, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

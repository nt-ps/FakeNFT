import UIKit

struct ErrorModel {
    let title: String?
    let message: String?
    let actionText: String
    let action: () -> Void
    let cancelText: String?
    let cancelAction: (() -> Void)?
    
    init(
        title: String?,
        message: String?,
        actionText: String,
        action: @escaping () -> Void,
        cancelText: String? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.actionText = actionText
        self.action = action
        self.cancelText = cancelText
        self.cancelAction = cancelAction
    }
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        var buttons: [AlertButton] = [
            AlertButton(text: model.actionText, action: model.action)
        ]
        
        if let cancelText = model.cancelText {
            buttons.append(
                AlertButton(
                    text: cancelText,
                    style: .cancel,
                    action: model.cancelAction ?? {}
                )
            )
        }
        
        let alertModel = AlertModel(
            title: model.title ?? L10n.Error.title,
            message: model.message,
            buttons: buttons
        )
        
        AlertPresenter.present(in: self, model: alertModel)
    }
}

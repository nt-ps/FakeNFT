//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit

protocol ViewControllerDelegate: UIViewController {}

final class AlertPresenter {
    private weak var viewControllerDelegate: ViewControllerDelegate?
    
    func setup(delegate: ViewControllerDelegate) {
        viewControllerDelegate = delegate
    }
    
    func present(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: alertModel.preferredStyle
        )

        for button in alertModel.buttons {
            let action = UIAlertAction(title: button.text, style: button.style) { _ in
                button.action()
            }
            alert.addAction(action)
        }

        viewControllerDelegate?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Static Methods
    static func present(in viewController: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.preferredStyle
        )

        for button in model.buttons {
            let action = UIAlertAction(title: button.text, style: button.style) { _ in
                button.action()
            }
            alert.addAction(action)
        }


        viewController.present(alert, animated: true)
    }
    
    static func presentTextFieldAlert(
        in viewController: UIViewController,
        title: String,
        message: String? = nil,
        placeholder: String,
        currentText: String = "",
        keyboardType: UIKeyboardType = .default,
        saveAction: @escaping (String) -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = currentText
            textField.keyboardType = keyboardType
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        
        let saveAction = UIAlertAction(title: L10n.EditProfile.Avatar.ChangeAlert.save, style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let urlString = textField.text,
                  !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            saveAction(urlString.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        let cancelAction = UIAlertAction(title: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel) { _ in
            cancelAction?()
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

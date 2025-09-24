//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let buttons: [AlertButton]
    let preferredStyle: UIAlertController.Style
    
    init(
        title: String,
        message: String? = nil,
        buttons: [AlertButton],
        preferredStyle: UIAlertController.Style = .alert
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.preferredStyle = preferredStyle
    }
}

struct AlertButton {
    let text: String
    let style: UIAlertAction.Style
    let action: () -> Void
    
    init(
        text: String,
        style: UIAlertAction.Style = .default,
        action: @escaping () -> Void = {}
    ) {
        self.text = text
        self.style = style
        self.action = action
    }
}

// MARK: - Common Alerts
extension AlertModel {
    static func error(message: String, completion: (() -> Void)? = nil) -> AlertModel {
        return AlertModel(
            title: L10n.Error.title,
            message: message,
            buttons: [
                AlertButton(text: L10n.Alert.ok, action: { completion?() })
            ]
        )
    }
    
    // MARK: Sort Action Sheet
    static func sortActionSheet(
        priceCompletion: @escaping () -> Void,
        ratingCompletion: @escaping () -> Void,
        nameCompletion: @escaping () -> Void
    ) -> AlertModel {
        return AlertModel(
            title: L10n.SortAlert.title,
            message: nil,
            buttons: [
                AlertButton(text: L10n.SortAlert.byPrice, action: priceCompletion),
                AlertButton(text: L10n.SortAlert.byRating, action: ratingCompletion),
                AlertButton(text: L10n.SortAlert.byName, action: nameCompletion),
                AlertButton(text: L10n.SortAlert.close, style: .cancel)
            ],
            preferredStyle: .actionSheet
        )
    }
    
    // MARK: Avatar Change Alert
    static func avatarChangeAlert(
        currentURL: String,
        saveAction: @escaping (String) -> Void
    ) -> AlertModel {
        return AlertModel(
            title: L10n.EditProfile.Avatar.ChangeAlert.title,
            message: nil,
            buttons: [
                AlertButton(text: L10n.EditProfile.Avatar.ChangeAlert.save) { },
                AlertButton(text: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel)
            ]
        )
    }
    
    // MARK: Avatar Delete Confirmation
    static func avatarDeleteConfirmation(
        deleteAction: @escaping () -> Void
    ) -> AlertModel {
        return AlertModel(
            title: L10n.EditProfile.Avatar.DeleteAlert.title,
            message: L10n.EditProfile.Avatar.DeleteAlert.message,
            buttons: [
                AlertButton(text: L10n.EditProfile.Avatar.DeleteAlert.delete, style: .destructive, action: deleteAction),
                AlertButton(text: L10n.EditProfile.Avatar.Alert.cancel, style: .cancel)
            ]
        )
    }
}

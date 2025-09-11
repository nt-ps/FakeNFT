//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
        static func style() {
            ProgressHUD.animationType = .systemActivityIndicator
            ProgressHUD.colorHUD = .AppColors.lightGray
            ProgressHUD.colorAnimation = .AppColors.black
        }

    private static var window: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

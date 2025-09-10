//
//  ProgressHUD.swift
//  FakeNFT
//
//  Created by oneche$$$ on 08.09.2025.
//

import UIKit
import ProgressHUD

final class ProgressHUDProvider {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func showProgressHUD() {
        ProgressHUD.colorAnimation = .black
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
        }
    }
    
    static func dismissProgressHUD() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}

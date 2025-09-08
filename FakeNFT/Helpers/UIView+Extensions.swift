//
//  UIView+Extensions.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 03.09.2025.
//

import UIKit

extension UIView {
    func enableKeyboardDismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func enableKeyboardDismissOnScroll(for scrollView: UIScrollView) {
        scrollView.keyboardDismissMode = .onDrag
    }

    @objc private func hideKeyboard() {
        endEditing(true)
    }
}

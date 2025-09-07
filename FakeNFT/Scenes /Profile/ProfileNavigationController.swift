//
//  ProfileNavigationController.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class ProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController(presenter: presenter)
        
        viewControllers = [viewController]
    }

}

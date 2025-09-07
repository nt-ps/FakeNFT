//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 02.09.2025.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .AppColors.white
        textLabel?.font = .bodyBold
        textLabel?.textColor = .AppColors.black
        
        let chevron  = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .AppColors.black
        accessoryView = chevron
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    
    func configCell(label: String) {
        textLabel?.text = label
    }

}

import UIKit

final class UserProfileNFTCollectionCell: UITableViewCell, ReuseIdentifying {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .AppColors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.textColor = .AppColors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var accessoryButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: "chevron.right")
        button.setImage(icon, for: .normal)
        button.tintColor = .AppColors.black
        button.sizeToFit()
        button.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(accessoryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            accessoryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with nftCount: Int) {
        titleLabel.text = "Коллекция NFT"
        countLabel.text = "(\(nftCount))"
    }
    
    @objc private func accessoryButtonTapped() {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        countLabel.text = nil
    }
}

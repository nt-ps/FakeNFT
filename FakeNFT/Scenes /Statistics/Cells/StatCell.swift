import UIKit
import Kingfisher

final class StatCell: UITableViewCell {
    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = UIColor(resource: .AppColors.black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .AppColors.lightGray)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .Icons.profileTab)
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor(resource: .AppColors.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.textColor = UIColor(resource: .AppColors.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        contentView.addSubview(positionLabel)
        contentView.addSubview(grayBackgroundView)
        
        grayBackgroundView.addSubview(avatarImage)
        grayBackgroundView.addSubview(nameLabel)
        grayBackgroundView.addSubview(nftCountLabel)
        
        NSLayoutConstraint.activate([
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            positionLabel.widthAnchor.constraint(equalToConstant: 20),
            
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            grayBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            grayBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            grayBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            avatarImage.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 28),
            avatarImage.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: nftCountLabel.leadingAnchor, constant: -16),
            
            nftCountLabel.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            nftCountLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with user: User, position: Int) {
        positionLabel.text = "\(position)"
        nameLabel.text = user.name
        nftCountLabel.text = "\(user.nftCount)"
        
        if let avatarURL = user.avatarURL {
            let placeholder = UIImage(resource: .Icons.profileTab)
            
            avatarImage.kf.setImage(
                with: avatarURL,
                placeholder: placeholder,
                options: [.transition(.fade(0.2))]
            )
        } else {
            avatarImage.image = UIImage(resource: .Icons.profileTab)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        positionLabel.text = nil
        nameLabel.text = nil
        avatarImage.image = nil
        avatarImage.kf.cancelDownloadTask()
        nftCountLabel.text = nil
    }
}

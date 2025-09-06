import UIKit

final class CollectionCollectionHeader: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - Views
    
    private lazy var cellStackView: UIStackView = {
        let cellStackView = UIStackView(
            arrangedSubviews: [coverImageView, infoStackView]
        )
        cellStackView.axis = .vertical
        cellStackView.alignment = .leading
        cellStackView.spacing = cellStackSpacing
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        return cellStackView
    } ()
    
    private lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.image = UIImage(resource: .CatalogueMock.peachCover) // TODO: Удалить!
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.masksToBounds = true
        coverImageView.layer.cornerRadius = coverCornerRadius
        coverImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        return coverImageView
    } ()
    
    private lazy var infoStackView: UIStackView = {
        let infoStackView = UIStackView(
            arrangedSubviews: [titleStackView, descriptionView]
        )
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        return infoStackView
    } ()
    
    private lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView(
            arrangedSubviews: [nameLabel, authorStackView]
        )
        titleStackView.axis = .vertical
        titleStackView.alignment = .leading
        titleStackView.spacing = titleStackSpacing
        return titleStackView
    } ()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Peach" // TODO: Удалить
        nameLabel.font = UIFont.headline3
        nameLabel.textColor = .AppColors.black
        nameLabel.textAlignment = .natural
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        return nameLabel
    } ()
    
    private lazy var authorStackView: UIStackView = {
        let authorStackView = UIStackView(
            arrangedSubviews: [authorCaptionLabel, authorButton]
        )
        authorStackView.axis = .horizontal
        authorStackView.spacing = authorStackSpacing
        return authorStackView
    } ()
    
    private lazy var authorCaptionLabel: UILabel = {
        let authorCaptionLabel = UILabel()
        authorCaptionLabel.text = L10n.Collection.authorCaption
        authorCaptionLabel.font = .caption2
        authorCaptionLabel.textColor = .AppColors.black
        authorCaptionLabel.textAlignment = .natural
        return authorCaptionLabel
    } ()
    
    private lazy var authorButton: UIButton = {
        let authorButton = UIButton(type: .custom)
        authorButton.setTitle("John Doe", for: .normal) // TODO: Удалить!
        authorButton.titleLabel?.lineBreakMode = .byTruncatingTail
        authorButton.contentHorizontalAlignment = .leading
        authorButton.titleLabel?.font = .caption1
        authorButton.setTitleColor(.AppColors.Universal.blue, for: .normal)
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        return authorButton
    } ()
    
    private lazy var descriptionView: UILabel = {
        let descriptionView = UILabel()
        descriptionView.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей." // TODO: Удалить
        descriptionView.font = UIFont.caption2
        descriptionView.textColor = .AppColors.black
        descriptionView.textAlignment = .natural
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.numberOfLines = 0
        return descriptionView
    } ()
    
    // MARK: - UI Properties
    
    private let cellStackSpacing: CGFloat = 16
    private let infoXSpacing: CGFloat = 16
    private let titleStackSpacing: CGFloat = 8
    private let authorStackSpacing: CGFloat = 4
    
    private let coverAspectRatio: CGFloat = 62.0 / 75.0
    private let coverCornerRadius: CGFloat = 12
    
    private let authorButtonHeight: CGFloat = 28

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(cellStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: CollectionCollectionHeader.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cellStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            cellStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
            
            coverImageView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor),
            coverImageView.topAnchor.constraint(equalTo: cellStackView.topAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor),
            coverImageView.heightAnchor.constraint(
                equalTo: coverImageView.widthAnchor,
                multiplier: coverAspectRatio
            ),
            
            infoStackView.leadingAnchor.constraint(
                equalTo: cellStackView.leadingAnchor,
                constant: infoXSpacing
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: cellStackView.trailingAnchor,
                constant: -infoXSpacing
            ),
            
            authorButton.heightAnchor.constraint(equalToConstant: authorButtonHeight)
        ])
    }
}

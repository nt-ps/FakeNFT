import UIKit
import Kingfisher

// MARK: - Delegate

protocol CollectionCollectionHeaderDelegate: AnyObject {
    func show(viewController: UIViewController)
    func show(error model: ErrorModel)
}

// MARK: - Header

final class CollectionCollectionHeader: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - Views
    
    private lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.backgroundColor = .AppColors.lightGray
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
        authorButton.titleLabel?.lineBreakMode = .byTruncatingTail
        authorButton.contentHorizontalAlignment = .leading
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        authorButton.addTarget(
            self,
            action: #selector(didTapAuthorButton),
            for: .touchUpInside
        )
        changeButtonState(authorButton, to: false)
        return authorButton
    } ()
    
    private lazy var descriptionView: UILabel = {
        let descriptionView = UILabel()
        descriptionView.font = UIFont.caption2
        descriptionView.textColor = .AppColors.black
        descriptionView.textAlignment = .natural
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.numberOfLines = 0
        return descriptionView
    } ()
    
    // MARK: - UI Properties
    
    private let infoStackXSpacing: CGFloat = 16
    private let infoStackTopSpacing: CGFloat = 16
    private let infoStackBottomSpacing: CGFloat = 4
    
    private let titleStackSpacing: CGFloat = 8
    private let authorStackSpacing: CGFloat = 4
    
    private let coverAspectRatio: CGFloat = 62.0 / 75.0
    private let coverCornerRadius: CGFloat = 12
    
    private let authorButtonHeight: CGFloat = 28
    
    private var coverHeightConstraint: NSLayoutConstraint?
    private var coverTopConstraint: NSLayoutConstraint?
    
    // MARK: - Internal Properties
    
    weak var delegate: CollectionCollectionHeaderDelegate?
    
    var cover: URL? {
        didSet (oldValue) {
            guard let cover, cover != oldValue else { return }
            coverImageView.kf.cancelDownloadTask()
            coverImageView.kf.setImage(with: cover)
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var authorName: String? {
        didSet {
            authorButton.setTitle(authorName, for: .normal)
        }
    }
    
    var authorWebsite: String? {
        didSet {
            let state = authorWebsite != nil
            changeButtonState(authorButton, to: state)
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionView.text = descriptionText
        }
    }

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(coverImageView)
        addSubview(infoStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: CollectionCollectionHeader.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden Methods
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        layoutAttributes.size = systemLayoutSizeFitting(
            layoutAttributes.size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapAuthorButton() {
        guard
            let authorWebsite,
            let url = URL(string: authorWebsite)
        else {
            let errorModel = ErrorModel(
                title: L10n.Error.unknown,
                message: nil,
                actionText: nil,
                action: nil
            )
            delegate?.show(error: errorModel)
            return
        }
        
        let assembly = WebViewAssembly()
        let request = URLRequest(url: url)
        let viewController = assembly.build(with: request)
        delegate?.show(viewController: viewController)
    }
    
    // MARK: - UI Updates
    
    func stretch(to delta: CGFloat) {
        if let coverHeightConstraint {
            NSLayoutConstraint.deactivate([coverHeightConstraint])
        }

        if let coverTopConstraint {
            NSLayoutConstraint.deactivate([coverTopConstraint])
        }
        
        coverTopConstraint = coverImageView.topAnchor.constraint(
            equalTo: topAnchor,
            constant: -delta
        )
        coverTopConstraint?.isActive = true
        
        coverHeightConstraint = coverImageView.heightAnchor.constraint(
            equalTo: coverImageView.widthAnchor,
            multiplier: coverAspectRatio,
            constant: delta
        )
        coverHeightConstraint?.isActive = true
    }
    
    private func changeButtonState(_ button: UIButton, to isEnabled: Bool) {
        button.setTitleColor(
            isEnabled ? .AppColors.Universal.blue : .AppColors.black,
            for: .normal
        )
        button.titleLabel?.font = isEnabled ? .caption1 : .caption2
        button.isEnabled = isEnabled
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            authorButton.heightAnchor.constraint(equalToConstant: authorButtonHeight),
            
            infoStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: infoStackXSpacing
            ),
            infoStackView.topAnchor.constraint(
                equalTo: coverImageView.bottomAnchor,
                constant: infoStackTopSpacing
            ),
            infoStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -infoStackXSpacing
            ),
            infoStackView.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomAnchor,
                constant: -infoStackBottomSpacing
            )
        ])
        
        stretch(to: 0)
    }
}

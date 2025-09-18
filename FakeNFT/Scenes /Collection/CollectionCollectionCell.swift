import UIKit
import Kingfisher

// MARK: - Delegate

protocol CollectionCollectionCellDelegate: AnyObject {
    func switchLike(for cell: CollectionCollectionCell)
    func switchStateInCart(for cell: CollectionCollectionCell)
}

// MARK: - Cell

final class CollectionCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .AppColors.lightGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private lazy var likeButton: LikeButton = {
        let likeButton = LikeButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(
            self,
            action: #selector(didTapLikeButton),
            for: .touchUpInside
        )
        return likeButton
    } ()
    
    private lazy var ratingView: RatingView = {
        let ratingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    } ()
    
    private lazy var footerStackView: UIStackView = {
        let footerStackView = UIStackView(
            arrangedSubviews: [titleStackView, cartButton]
        )
        footerStackView.axis = .horizontal
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        return footerStackView
    } ()

    private lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView(
            arrangedSubviews: [nameLabel, priceLabel]
        )
        titleStackView.axis = .vertical
        titleStackView.spacing = titleStackSpacing
        return titleStackView
    } ()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.bodyBold
        nameLabel.textColor = .AppColors.black
        nameLabel.textAlignment = .natural
        nameLabel.lineBreakMode = .byCharWrapping
        return nameLabel
    } ()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.caption3
        priceLabel.textColor = .AppColors.black
        priceLabel.textAlignment = .natural
        priceLabel.lineBreakMode = .byCharWrapping
        return priceLabel
    } ()
    
    private lazy var cartButton: CartButton = {
        let cartButton = CartButton()
        cartButton.tintColor = .AppColors.black
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addTarget(
            self,
            action: #selector(didTapCartButton),
            for: .touchUpInside
        )
        return cartButton
    } ()
    
    // MARK: - UI Properties
    
    private let imageCornerRadius: CGFloat = 12
    private let titleStackSpacing: CGFloat = 4
    private let buttonsSize: CGFloat = 40
    private let ratingTopSpacing: CGFloat = 8
    private let ratingHeight: CGFloat = 12
    private let footerStackTopSpacing: CGFloat = 4
    private let footerStackBottomSpacing: CGFloat = 20
    
    // MARK: - Internal Properties
    
    weak var delegate: CollectionCollectionCellDelegate?
    
    var image: URL? {
        didSet (oldValue) {
            guard let image, image != oldValue else { return }
            imageView.kf.cancelDownloadTask()
            imageView.kf.setImage(with: image)
        }
    }
    
    var rating: UInt? {
        didSet {
            ratingView.value = rating ?? 0
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var price: Float? {
        didSet {
            // TODO: После слития заюзать CurrencyFormatter.
            priceLabel.text = String(format: "%.2f", price ?? 0) + " ETH"
        }
    }
    
    var isLiked: Bool? {
        didSet {
            likeButton.isActive = isLiked ?? false
        }
    }
    
    var inCart: Bool? {
        didSet {
            cartButton.isActive = inCart ?? false
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(likeButton)
        addSubview(ratingView)
        addSubview(footerStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: CatalogueTableCell.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden Methods
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let size = systemLayoutSizeFitting(
            layoutAttributes.size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.size = size
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapLikeButton() {
        delegate?.switchLike(for: self)
    }
    
    @objc
    private func didTapCartButton() {
        delegate?.switchStateInCart(for: self)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: buttonsSize),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
            
            ratingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: ratingTopSpacing
            ),
            ratingView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: ratingHeight),
            
            footerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerStackView.topAnchor.constraint(
                equalTo: ratingView.bottomAnchor,
                constant: footerStackTopSpacing
            ),
            footerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -footerStackBottomSpacing
            ),
            
            cartButton.widthAnchor.constraint(equalToConstant: buttonsSize),
            cartButton.heightAnchor.constraint(equalTo: cartButton.widthAnchor)
        ])
    }
}

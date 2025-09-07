import UIKit
import Kingfisher

final class CatalogueTableCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Views
    
    private lazy var cellStackView: UIStackView = {
        let cellStackView = UIStackView(
            arrangedSubviews: [coverView, labelStackView]
        )
        cellStackView.axis = .vertical
        cellStackView.alignment = .leading
        cellStackView.spacing = stackViewSpacing
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        return cellStackView
    } ()
    
    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.clipsToBounds = true
        coverView.layer.masksToBounds = true
        coverView.layer.cornerRadius = coverCornerRadius
        coverView.backgroundColor = .AppColors.lightGray
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.addSubview(coverImageView)
        return coverView
    } ()
    
    private lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.kf.indicatorType = .none
        return coverImageView
    } ()
    
    private lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView(
            arrangedSubviews: [nameLabel, numLabel]
        )
        labelStackView.axis = .horizontal
        labelStackView.spacing = stackViewSpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    } ()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyBold
        nameLabel.textColor = .AppColors.black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    } ()
    
    private lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.font = .bodyBold
        numLabel.textColor = .AppColors.black
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        return numLabel
    } ()
    
    // MARK: - UI Properties
    
    private let stackViewSpacing: CGFloat = 4
    
    private let coverCornerRadius: CGFloat = 12
    private let coverHeight: CGFloat = 140
    private var coverHeightConstraint: NSLayoutConstraint?
    
    private let xSpacing: CGFloat = 16
    private let ySpacing: CGFloat = 10
    
    // MARK: - Internal Properties
    
    var cover: URL? {
        didSet (oldValue) {
            guard let cover, cover != oldValue else { return }
    
            coverImageView.kf.cancelDownloadTask()
            coverImageView.kf.setImage(
                with: cover,
                completionHandler: { [weak self] result in
                    guard let image = try? result.get() else { return }
                    self?.updateCoverConstraints(by: image.image.size)
                }
            )
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var counterValue: Int? {
        didSet {
            numLabel.text = "(\(counterValue ?? 0))"
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(cellStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: CatalogueTableCell.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: xSpacing
            ),
            cellStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: ySpacing
            ),
            cellStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -xSpacing
            ),
            cellStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -ySpacing
            ),
        
            coverView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor),
            coverView.topAnchor.constraint(equalTo: cellStackView.topAnchor),
            coverView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor),
            coverView.heightAnchor.constraint(equalToConstant: coverHeight),
            
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor)
        ])
    }
    
    private func updateCoverConstraints(by size: CGSize) {
        if let coverHeightConstraint {
            NSLayoutConstraint.deactivate([coverHeightConstraint])
        }
        let coverHeightRatio = size.height / size.width
        coverHeightConstraint = coverImageView.heightAnchor.constraint(
            equalTo: coverImageView.widthAnchor,
            multiplier: coverHeightRatio
        )
        coverHeightConstraint?.isActive = true
    }
}

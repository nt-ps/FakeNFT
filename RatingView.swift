import UIKit

final class RatingView: UIView {
    
    // MARK: - Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = minStackSpacing
        starImageViews.forEach { stackView.addArrangedSubview($0) }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private lazy var starImageViews: [UIImageView] = {
        var starImageViews: [UIImageView] = []
        for i in 0..<maxValue {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            setImage(of: imageView, isActive: false)
            starImageViews.append(imageView)
        }
        return starImageViews
    } ()
    
    // MARK: - UI Properties
    
    private let activeIconResource: ImageResource = .Icons.Star.active
    private let noActiveIconResource: ImageResource = .Icons.Star.noActive
    
    private let minStackSpacing: CGFloat = 2
    
    // MARK: - Internal Properties
    
    var value: UInt = 0 {
        didSet (oldValue) {
            if value != oldValue && value <= maxValue {
                for i in 0..<maxValue {
                    setImage(of: starImageViews[i], isActive: i < value)
                }
            }
        }
    }
    
    // MARK: - Private Properties
    
    private let maxValue: Int = 5
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: RatingView.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func setImage(of imageView: UIImageView, isActive: Bool) {
        let imageResource = isActive ? activeIconResource : noActiveIconResource
        imageView.image = UIImage(resource: imageResource)
    }
}

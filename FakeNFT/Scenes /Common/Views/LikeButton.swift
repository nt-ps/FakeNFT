import UIKit

final class LikeButton: UIButton {
    
    // MARK: - Internal Properties
    
    var isActive: Bool = false {
        didSet (oldValue) {
            if isActive != oldValue{
                setImage(isActive: isActive)
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let activeIconResource: ImageResource = .Icons.Like.active
    private let noActiveIconResource: ImageResource = .Icons.Like.noActive
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(type: UIButton.ButtonType.custom)
        self.setImage(isActive: isActive)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(isActive: isActive)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: LikeButton.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setImage(isActive: Bool) {
        let imageResource = isActive ? activeIconResource : noActiveIconResource
        let image = UIImage(resource: imageResource)
        setImage(image, for: .normal)
    }
}

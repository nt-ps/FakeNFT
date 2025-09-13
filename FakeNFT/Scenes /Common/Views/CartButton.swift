import UIKit

final class CartButton: UIButton {
    
    // MARK: - Internal Properties
    
    var isActive: Bool = false {
        didSet (oldValue) {
            if isActive != oldValue{
                setImage(isActive: isActive)
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let activeIconResource: ImageResource = .Icons.Cart.delete
    private let noActiveIconResource: ImageResource = .Icons.Cart.add
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(type: UIButton.ButtonType.system)
        self.setImage(isActive: isActive)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(isActive: isActive)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(String(describing: CartButton.self)).init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setImage(isActive: Bool) {
        let imageResource = isActive ? activeIconResource : noActiveIconResource
        let image = UIImage(resource: imageResource)
        setImage(image, for: .normal)
    }
}

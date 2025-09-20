import UIKit


final class StripPageControl: UIView {
    var numberOfPages: Int = 3 {
        didSet { setupStrips() }
    }
    
    var currentPage: Int = 0 {
        didSet { updateColors() }
    }
    
    private let stackView = UIStackView()
    private var strips: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        setupStrips()
    }
    
    private func setupStrips() {
        strips.forEach { $0.removeFromSuperview() }
        strips.removeAll()
        
        for _ in 0..<numberOfPages {
            let strip = UIView()
            strip.backgroundColor = .AppColors.lightGray
            strip.layer.cornerRadius = 2
            strip.translatesAutoresizingMaskIntoConstraints = false
            
            strips.append(strip)
            stackView.addArrangedSubview(strip)
            
            NSLayoutConstraint.activate([
                strip.heightAnchor.constraint(equalToConstant: 4)
            ])
        }
        
        updateColors()
    }
    
    private func updateColors() {
        for (index, strip) in strips.enumerated() {
            strip.backgroundColor = index == currentPage ? .AppColors.Universal.white : .AppColors.Universal.gray
        }
    }
}

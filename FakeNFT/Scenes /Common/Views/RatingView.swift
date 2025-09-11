//
//  RatingView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 10.09.2025.
//

import UIKit

final class RatingView: UIStackView {

    // MARK: Properties
    private var rating: Int = 0
    
    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func setRating(rating: Int) {
        self.rating = max(0, min(5, rating))
        updateStars()
    }

    private func setupStackView() {
        spacing = 2
        axis = .horizontal
        distribution = .fillEqually
        
        for _ in 0..<5 {
            let imageView = createStarImageView()
            addArrangedSubview(imageView)
        }
    }
    
    private func createStarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func updateStars() {
        for (index, subview) in subviews.enumerated() {
            guard let imageView = subview as? UIImageView else { continue }
            imageView.image = index < rating ? .Icons.Star.active : .Icons.Star.noActive
        }
    }
}

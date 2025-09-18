//
//  BaseImageView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit
import Kingfisher
import SkeletonView

class BaseImageView: UIImageView {
    
    // MARK: Properties
    let size: CGFloat
    let cornerRadius: CGFloat
    let defaultSystemImage: String
    let fallbackSystemImage: String
    
    // MARK: Initializers
    init(size: CGFloat, cornerRadius: CGFloat, defaultSystemImage: String, fallbackSystemImage: String) {
        self.size = size
        self.cornerRadius = cornerRadius
        self.defaultSystemImage = defaultSystemImage
        self.fallbackSystemImage = fallbackSystemImage
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupView() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        isSkeletonable = true
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    // MARK: Methods
    func setImage(urlString: String?) {
        guard let urlString = urlString,
              !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Empty or nil image URL, showing default icon")
            setDefaultImage()
            return
        }
        
        let cleanedURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedURL.isEmpty || cleanedURL == "-" || cleanedURL == "." || cleanedURL == "null" {
            print("URL contains only special characters: '\(cleanedURL)', showing default icon")
            setDefaultImage()
            return
        }
        
        if urlString.hasPrefix("local://") {
            let imageName = String(urlString.dropFirst(8))
            loadLocalImage(named: imageName)
            return
        }
        
        if urlString.contains("/ipfs/") {
            if let ipfsHash = extractIPFSHash(from: urlString) {
                let fastGateway = "https://ipfs.io/ipfs/\(ipfsHash)"
                loadImageFromURL(URL(string: fastGateway))
                return
            }
        }
        
        loadImageFromURL(URL(string: urlString))
    }
    
    private func loadImageFromURL(_ url: URL?) {
        guard let url else {
            print("Invalid URL, showing default image")
            setDefaultImage()
            return
        }
        
        guard url.scheme != nil && url.host != nil else {
            print("URL missing scheme or host: \(url.absoluteString)")
            setDefaultImage()
            return
        }
        
        kf.indicatorType = .activity
        
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .memoryCacheExpiration(.days(7)),
            .diskCacheExpiration(.days(30)),
            .transition(.fade(0.2))
        ]
        
        kf.setImage(with: url, options: options) { [weak self] result in
            switch result {
            case .success(_):
                print("Image loaded successfully")
            case .failure(let error):
                print("Image loading failed: \(error)")
                DispatchQueue.main.async {
                    self?.setDefaultImage()
                }
            }
        }
    }
    
    private func setDefaultImage() {
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium)
        let defaultImage = UIImage(systemName: defaultSystemImage, withConfiguration: config)

        if let defaultImage = defaultImage {
            image = defaultImage
            backgroundColor = .systemGray6
            tintColor = .systemGray3
        } else {
            let fallbackConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
            let fallbackImage = UIImage(systemName: fallbackSystemImage, withConfiguration: fallbackConfig)
            image = fallbackImage
            backgroundColor = .systemGray5
            tintColor = .systemGray2
        }
    }
    
    private func loadLocalImage(named imageName: String) {
        // Try to load image using the new resource system first
        if let image = UIImage(named: imageName) {
            self.image = image
            backgroundColor = .clear
            return
        }
        
        // Fallback to default image if local image not found
        print("Local image '\(imageName)' not found, showing default icon")
        setDefaultImage()
    }
    
    private func extractIPFSHash(from urlString: String) -> String? {
        guard let range = urlString.range(of: "/ipfs/") else { return nil }
        
        let startIndex = urlString.index(range.upperBound, offsetBy: 0)
        return String(urlString[startIndex...])
    }
}

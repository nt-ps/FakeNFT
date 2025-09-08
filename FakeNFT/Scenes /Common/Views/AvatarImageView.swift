//
//  AvatarImageView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 01.09.2025.
//

import UIKit
import Kingfisher
import SkeletonView

final class AvatarImageView: UIImageView {

    private enum Constants {
        static let size: CGFloat = 70
    }

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.size / 2
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        isSkeletonable = true
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Constants.size),
            heightAnchor.constraint(equalToConstant: Constants.size)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAvatar(urlString: String?) {
        guard let urlString = urlString,
              !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Empty or nil avatar URL, showing default user icon")
            setDefaultAvatar()
            return
        }
        
        let cleanedURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedURL.isEmpty || cleanedURL == "-" || cleanedURL == "." || cleanedURL == "null" {
            print("URL contains only special characters: '\(cleanedURL)', showing default user icon")
            setDefaultAvatar()
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
        guard let url = url else {
            print("Invalid URL, showing default avatar")
            setDefaultAvatar()
            return
        }
        
        guard url.scheme != nil && url.host != nil else {
            print("URL missing scheme or host: \(url.absoluteString)")
            setDefaultAvatar()
            return
        }
        
        kf.indicatorType = .activity
        
        let options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .memoryCacheExpiration(.days(7)),
            .diskCacheExpiration(.days(30)),
            .transition(.fade(0.2))
        ]
        
        kf.setImage(with: url, options: options) { result in
            switch result {
            case .success(let imageResult):
                print("Avatar loaded successfully: \(imageResult.image.size)")
            case .failure(let error):
                print("Avatar loading failed: \(error)")
                DispatchQueue.main.async {
                    self.setDefaultAvatar()
                }
            }
        }
    }
    
    private func setDefaultAvatar() {
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium)
        let defaultImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        
        if let defaultImage = defaultImage {
            image = defaultImage
            backgroundColor = .systemGray6
            tintColor = .systemGray3
        } else {
            let fallbackConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
            let fallbackImage = UIImage(systemName: "person", withConfiguration: fallbackConfig)
            image = fallbackImage
            backgroundColor = .systemGray5
            tintColor = .systemGray2
        }
        
        print("Set default avatar with user icon")
    }
    
    private func isValidHost(_ host: String) -> Bool {
        let validGateways = ["ipfs.io", "dweb.link"]
        return validGateways.contains(host) || host == "localhost"
    }
    
    private func extractIPFSHash(from urlString: String) -> String? {
        guard let range = urlString.range(of: "/ipfs/") else { return nil }
        
        let startIndex = urlString.index(range.upperBound, offsetBy: 0)
        return String(urlString[startIndex...])
    }
}

//
//  NFTImageView.swift
//  FakeNFT
//
//  Created by Amina Khusnutdinova on 07.09.2025.
//

import UIKit

final class NFTImageView: BaseImageView {
    
    // MARK: Properties
    private enum Constants {
        static let size: CGFloat = 40
    }
    
    private let likeButton = UIButton(type: .custom)
    private var isLiked: Bool = false
    private var nftId: String?
    var onLikeTapped: ((Bool) -> Void)?
    var onLikeError: ((String) -> Void)?
    
    // MARK: Initializers
    init() {
        super.init(
            size: 108,
            cornerRadius: 12,
            defaultSystemImage: "photo",
            fallbackSystemImage: "photo.fill"
        )
        setupLikeButton()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func setNFTImage(urlString: String?) {
        setImage(urlString: urlString)
    }
    
    func setLiked(_ liked: Bool) {
        isLiked = liked
        updateLikeButton()
    }
    
    func setNFTId(_ id: String) {
        nftId = id
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.isUserInteractionEnabled = true
        likeButton.isExclusiveTouch = true
        
        addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.size),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.size)
        ])
        
        updateLikeButton()
    }
    
    private func updateLikeButton() {
        let image = isLiked ? UIImage.Icons.Like.active : UIImage.Icons.Like.noActive
        likeButton.setImage(image, for: .normal)
        likeButton.contentMode = .scaleAspectFit
    }
    
    @objc private func likeButtonTapped() {
        guard let nftId = nftId else {
            return
        }
        
        setLikeRequest(nftId: nftId, isLiked: isLiked)
    }
    
    private func setLikeRequest(nftId: String, isLiked: Bool) {
        let currentProfile = ProfileStorage.shared.profile
        
        guard let profile = currentProfile else {
            print("No profile found in storage")
            onLikeError?("Профиль не найден. Пожалуйста, обновите приложение.")
            return
        }
        
        var updatedLikes = profile.likes
        
        isLiked ? updatedLikes.removeAll { $0 == nftId } : updatedLikes.append(nftId)
        
        
        let profileService = ProfileService.shared
        
        profileService.setLikeRequest(likes: updatedLikes) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLiked.toggle()
                    self?.updateLikeButton()
                    self?.onLikeTapped?(self?.isLiked ?? false)
                case .failure(let error):
                    print("Like request failed: \(error)")
                    self?.onLikeError?("Не удалось обновить лайк. Попробуйте еще раз.")
                }
            }
        }
    }
}

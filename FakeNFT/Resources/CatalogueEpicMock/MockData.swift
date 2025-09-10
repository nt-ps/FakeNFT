import UIKit

struct MockData {
    static var nfts: [Nft] = [
        Nft(
            name: "Archie", coverImage: UIImage(resource: .NftMock.archieCover),
            rating: 2, price: 1, id: "Archie"
        ),
        
        Nft(
            name: "Art", coverImage: UIImage(resource: .NftMock.artCover),
            rating: 3, price: 1, id: "Art"
        ),
        
        Nft(
            name: "Nacho", coverImage: UIImage(resource: .NftMock.nachoCover),
            rating: 2, price: 2, id: "Nacho"
        ),
        
        Nft(
            name: "Tater", coverImage: UIImage(resource: .NftMock.taterCover),
            rating: 4, price: 1, id: "Tater"
        ),
        
        Nft(
            name: "Tater_1", coverImage: UIImage(resource: .NftMock.taterCover),
            rating: 4, price: 1, id: "Tater_1"
        ),
        
        Nft(
            name: "Tater_2", coverImage: UIImage(resource: .NftMock.taterCover),
            rating: 4, price: 1, id: "Tater_2"
        ),
        
        Nft(
            name: "Tater_3", coverImage: UIImage(resource: .NftMock.taterCover),
            rating: 4, price: 1, id: "Tater_3"
        ),
        
        Nft(
            name: "Tater_4", coverImage: UIImage(resource: .NftMock.taterCover),
            rating: 4, price: 1, id: "Tater_4"
        ),
        
        Nft(
            name: "Tater_5", coverImage: UIImage(resource: .NftMock.taterCover),
            rating: 4, price: 1, id: "Tater_5"
        )
    ]
}

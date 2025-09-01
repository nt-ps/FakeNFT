import UIKit

struct MockData {
    private static var collections: [Collection] = [
        Collection(
            name: "Peach",
            coverImage: UIImage(resource: .CatalogueMock.peachCover),
            nfts: ["Archie", "Art", "Nacho", "Tater"],
            description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
            author: "John Doe",
            id: "Peach"
        ),
        
        Collection(
            name: "Brown", coverImage: UIImage(resource: .CatalogueMock.brownCover),
            nfts: [], description: "", author: "Author", id: "Brown"
        ),
        
        Collection(
            name: "White", coverImage: UIImage(resource: .CatalogueMock.whiteCover),
            nfts: [], description: "", author: "Author", id: "White"
        ),
        
        Collection(
            name: "Gray", coverImage: UIImage(resource: .CatalogueMock.grayCover),
            nfts: [], description: "", author: "Author", id: "Gray"
        ),
        
        Collection(
            name: "Yellow", coverImage: UIImage(resource: .CatalogueMock.yellowCover),
            nfts: [], description: "", author: "Author", id: "Yellow"
        ),
        
        Collection(
            name: "Green", coverImage: UIImage(resource: .CatalogueMock.greenCover),
            nfts: [], description: "", author: "Author", id: "Green"
        ),
        
        Collection(
            name: "Blue", coverImage: UIImage(resource: .CatalogueMock.blueCover),
            nfts: [], description: "", author: "Author", id: "Blue"
        ),
        
        Collection(
            name: "Beige", coverImage: UIImage(resource: .CatalogueMock.beigeCover),
            nfts: [], description: "", author: "Author", id: "Beige"
        ),
        
        Collection(
            name: "Pink", coverImage: UIImage(resource: .CatalogueMock.pinkCover),
            nfts: [], description: "", author: "Author", id: "Pink"
        )
    ]
    
    private static var nfts: [Nft] = [
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
    ]
    
    private static var collectionsSortedByName: [Collection] = collections.sorted { $0.name < $1.name }
    
    static func getPage(sortBy: CollectionFields, num: Int, size: Int) -> [Collection] {
        let firstIndex = num * size
        var lastIndex = firstIndex + size
        lastIndex = lastIndex > collections.count ? collections.count : lastIndex
        
        switch sortBy {
        case .name:
            return Array(collectionsSortedByName[firstIndex..<lastIndex])
        default:
            return Array(collections[firstIndex..<lastIndex])
        }
    }
}

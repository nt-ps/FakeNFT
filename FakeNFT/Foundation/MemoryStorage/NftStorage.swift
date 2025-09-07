import Foundation

// TODO: Подумать над тем, чтобы реализовать кэш через CoreData.
// Доводы за:     При перезапуске приложения кэш удаляется.
// Доводы против: Информация об NFT (особенно цена и рейтинг)
//                может измениться на сервере, поэтому каким-то образом
//                ее нужно обновлять в кэше.

protocol NftStorage: AnyObject {
    func saveNft(_ nft: Nft)
    func saveNfts(_ nfts: [Nft])
    func getNft(with id: String) -> Nft?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: Nft] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func saveNfts(_ nfts: [Nft]) {
        syncQueue.async { [weak self] in
            nfts.forEach { nft in
                self?.storage[nft.id] = nft
            }
        }
    }
    
    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }
}

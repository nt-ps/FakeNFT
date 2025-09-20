import Foundation

// TODO: Скопировал сервис Вани, внес мелкие корректировки.
//       Помнить про это при слиянии.

struct Order: Decodable {
    let nfts: [String]
    let id: String
}

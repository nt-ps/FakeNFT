//
//  Payment (model).swift
//  FakeNFT
//
//  Created by oneche$$$ on 17.09.2025.
//

import Foundation

struct Payment: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}

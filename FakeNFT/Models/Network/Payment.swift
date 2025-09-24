//
//  Payment (model).swift
//  FakeNFT
//
//  Created by oneche$$$ on 20.09.2025.
//

import Foundation

struct Payment: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}

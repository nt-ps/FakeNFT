//
//  OrderService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 08.09.2025.
//

import Foundation



protocol OrderServiceProtocol {
    func fetchOrder(completion: @escaping ((Order) -> Void))
}


// MARK: Order model
struct Order: Codable {
    let nfts: [String]
    let id: String
}



final class OrderServiceImplementation: OrderServiceProtocol {

    func fetchOrder(completion: @escaping ((Order) -> Void)) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/orders/1")
        else {
            print("could't create url from string in OrderServiceImplementation")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("9d1a8c12-5515-4d8b-a683-c4c2f1148d62", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("error in OrderServiceImplementation: \(error)")
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200, let data else {
                print("status code in OrderServiceImplementation is not 200: \(statusCode ?? 0)")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(Order.self, from: data)
                completion(decodedData)
            } catch {
                print("error in OrderServiceImplementation while decoding data: \(error)")
            }
        }
        task.resume()
    }
}

//
//  PostNewShoppingCartService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import Foundation

protocol PutNewOrderServiceProtocol {
    func postNewOrder(with NFTs: [String], completion: @escaping (Result<Order, Error>) -> Void)
}

final class PutNewOrderServiceImplementation: PutNewOrderServiceProtocol {
    func postNewOrder(with NFTs: [String], completion: @escaping (Result<Order, Error>) -> Void) {
        let stringWithCommaSeparatedNFTsIds = NFTs.joined(separator: ", ")
        let neededStringForURL = NFTs.count > 0 ? "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/orders/1?nfts=\(stringWithCommaSeparatedNFTsIds)" : "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/orders/1"
        guard let url = URL(string: neededStringForURL) else {
            print("could't create url from string in OrderServiceImplementation")
            DispatchQueue.main.async {
                completion(.failure(OrderServiceError.orderError))
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("error in PostNewShoppingCartServiceImplementation: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200, let data else {
                print("status code in PostNewShoppingCartServiceImplementation is not 200: \(statusCode ?? 0)")
                DispatchQueue.main.async {
                    completion(.failure(OrderServiceError.orderError))
                }
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(Order.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("error in OrderServiceImplementation while decoding data: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

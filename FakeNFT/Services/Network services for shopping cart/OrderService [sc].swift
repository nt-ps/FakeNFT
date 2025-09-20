//
//  OrderService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 08.09.2025.
//

import Foundation

enum OrderServiceError: Error {
    case orderError
}

protocol OrderServiceProtocol {
    func fetchOrder(completion: @escaping (Result<Order, Error>) -> Void)
}

final class OrderServiceImplementation: OrderServiceProtocol {
    func fetchOrder(completion: @escaping (Result<Order, Error>) -> Void) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/orders/1")
        else {
            print("could't create url from string in OrderServiceImplementation")
            DispatchQueue.main.async {
                completion(.failure(OrderServiceError.orderError))
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("error in OrderServiceImplementation: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200, let data else {
                print("status code in OrderServiceImplementation is not 200: \(statusCode ?? 0)")
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

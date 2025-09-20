//
//  PaymentService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 20.09.2025.
//

import Foundation

protocol PaymentServiceProtocol {
    func payOrderWithCurrencyID(_ id: String, completion: @escaping ((Payment?) -> Void))
}

final class PaymentService: PaymentServiceProtocol {
    private let decoder = JSONDecoder()
    
    func payOrderWithCurrencyID(_ id: String, completion: @escaping ((Payment?) -> Void)) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/orders/1/payment/\(id)")
        else {
            print("could't create url from string in PaymentService")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                print("error in PaymentService: \(error)")
                completion(nil)
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200, let data else {
                print("status code in PaymentService is not 200: \(statusCode ?? 0)")
                completion(nil)
                return
            }
            do {
                let decodedData = try self.decoder.decode(Payment.self, from: data)
                completion(decodedData)
            } catch {
                print("error in PaymentService while decoding data: \(error)")
            }
        }
        task.resume()
    }
}

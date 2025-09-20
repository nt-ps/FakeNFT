//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 13.09.2025.
//

import Foundation

protocol CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ([Currency]) -> Void)
}

final class CurrenciesService: CurrenciesServiceProtocol {
    private let decoder = JSONDecoder()
    
    func fetchCurrencies(completion: @escaping ([Currency]) -> Void) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/currencies")
        else {
            print("could't create url from string in CurrenciesService")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                print("error in CurrenciesService: \(error)")
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200, let data else {
                print("status code in CurrenciesService is not 200: \(statusCode ?? 0)")
                return
            }
            do {
                let decodedData = try self.decoder.decode([Currency].self, from: data)
                completion(decodedData)
            } catch {
                print("error in CurrenciesService while decoding data: \(error)")
            }
        }
        task.resume()
    }
}

//
//  PostNewShoppingCartService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 10.09.2025.
//

import Foundation



protocol PutNewShoppingCartServiceProtocol {
    func postNewShoppingCart(with NFTs: [NFT])
}



final class PutNewShoppingCartServiceImplementation: PutNewShoppingCartServiceProtocol {
    func postNewShoppingCart(with NFTs: [NFT]) {
        let stringWithCommaSeparatedNFTsIds = NFTs.map { $0.id }.joined(separator: ", ")
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/orders/1?nfts=\(stringWithCommaSeparatedNFTsIds)")
        else {
            print("could't create url from string in OrderServiceImplementation")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("error in PostNewShoppingCartServiceImplementation: \(error)")
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200 else {
                print("status code in PostNewShoppingCartServiceImplementation is not 200: \(statusCode ?? 0)")
                return
            }
        }
        task.resume()
    }
}

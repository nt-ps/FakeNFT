//
//  NFTService.swift
//  FakeNFT
//
//  Created by oneche$$$ on 08.09.2025.
//

import Foundation



protocol NFTByIDServiceProtocol {
    func getNFTByID(id: String, completion: @escaping ((NFT) -> Void))
}



final class NFTByIDServiceImplementation: NFTByIDServiceProtocol {
    func getNFTByID(id: String, completion: @escaping ((NFT) -> Void)) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net//api/v1/nft/\(id)")
        else {
            print("could't create url from string in OrderServiceImplementation")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
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
                let decodedData = try JSONDecoder().decode(NFT.self, from: data)
                completion(decodedData)
            } catch {
                print("error in OrderServiceImplementation while decoding data: \(error)")
            }
        }
        task.resume()
    }
}

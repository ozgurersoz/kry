//
//  DataLoader.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

class NetworkManager {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func loadData<ResponseModel: Decodable>(_ urlRequest: URLRequest,
                                           responseObject: ResponseModel.Type,
                                           completion: @escaping (Result<ResponseModel, NetworkError>) -> Void) {
        urlSession.dataTask(with: urlRequest) { [weak self] (result) in
            guard let self: NetworkManager = self else { return }
            switch result {
                case .success(let (response, data)):
                    guard let code = (response as? HTTPURLResponse)?.statusCode,
                        let statusCode = HTTPStatusCode(rawValue: code) else {
                        return completion(.failure(.invalidResponse(nil)))
                    }
                
                    switch statusCode.responseType {
                    case .success:
                        // Return value if success [200..300)
                        guard let successResponse = self.responseDecoder(from: data, responseObject: ResponseModel.self) else {
                            return completion(.failure(.decodeError))
                        }
                        completion(.success(successResponse))
                    default:
                        // Other cases [300..500]
                        completion(.failure(.apiError))
                    }
                case .failure(let error):
                    print("API ERROR \(error.localizedDescription)")
                    completion(.failure(.apiError))
                }
         }.resume()
    }
    
    func removeData(_ urlRequest: URLRequest,
                  completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        urlSession.dataTaskWithoutData(with: urlRequest) { (result) in
           switch result {
               case .success(let response):
                   guard let code = (response as? HTTPURLResponse)?.statusCode,
                       let statusCode = HTTPStatusCode(rawValue: code) else {
                       return completion(.failure(.invalidResponse(nil)))
                   }
               
                   switch statusCode.responseType {
                   case .success:
                       // Return value if success [200..300)
                       completion(.success(true))
                   default:
                       // Other cases [300..500]
                       completion(.failure(.apiError))
                   }
               case .failure(let error):
                   print("API ERROR \(error.localizedDescription)")
                   completion(.failure(.apiError))
               }
        }.resume()
    }
    
    private func responseDecoder<ResponseModel: Decodable>(from data: Data, responseObject: ResponseModel.Type) -> ResponseModel? {
        do {
            let jsonDecoder = JSONDecoder()
            let decodedResponse = try jsonDecoder.decode(responseObject.self, from: data)
            return decodedResponse
        } catch {
            print("DECODE ERROR \(error.localizedDescription)")
            return nil
        }
    }
}

private extension NetworkManager {
    struct APIError: Decodable {
        let statusCode: Int?
        let service: String?
        let message: String
    }
}

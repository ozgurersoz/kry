//
//  URLSession+DataTask.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation
protocol URLSessionProtocol {
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask
    func dataTaskWithoutData(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse), Error>) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "Uppss.. Something is wrong!", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
    func dataTaskWithoutData(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response else {
                let error = NSError(domain: "Uppss.. Something is wrong!", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response)))
        }
    }
}

//
//  URLSesssion+Extensions.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

extension URLRequest {
    static func prepareForRequest(to path: String,
                                  method: HTTPMethod,
                                  headers: [String: String] = [:],
                                  body: [String: Any]? = nil,
                                  queryItems: [URLQueryItem] = []) throws -> URLRequest {
        guard let url = self.setUrl(path, queryItems: queryItems) else {
             throw NetworkError.invalidEndpoint
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach({ (field, value) in
            request.addValue(value, forHTTPHeaderField: field)
        })
        
        if let body = body {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = data
            } catch {
                throw NetworkError.invalidEndpoint
            }
        }
        
        return request
    }
    
    static private func setUrl(_ path: String, queryItems: [URLQueryItem] = [] ) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "app-code-test.kry.pet"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

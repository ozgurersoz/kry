//
//  NetworkError.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation
enum NetworkError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse(_ statusCode: HTTPStatusCode?)
    case noData
    case decodeError
    
    var message: String {
        switch self {
        case .apiError:
            return "Something went wrong"
        case .invalidResponse(let statusCode):
            return "StatusCode: \(String(describing: statusCode))"
        default:
            return "you shall not pass"
        }
    }
}

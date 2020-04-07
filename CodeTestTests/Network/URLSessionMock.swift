//
//  URLSessionMock.swift
//  CodeTestTests
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    var data: Data?
    var error: Error?
    var statusCode: Int
    
    init(statusCode: Int, data: Data?) {
        self.statusCode = statusCode
        self.data = data
    }

    override func dataTask(
        with url: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error

        return URLSessionDataTaskMock {
            let httpURLResponse = HTTPURLResponse(
                url: url.url!,
                statusCode: self.statusCode,
                httpVersion: nil,
                headerFields: nil
            )
            completionHandler(data, httpURLResponse, error)
        }
    }
}

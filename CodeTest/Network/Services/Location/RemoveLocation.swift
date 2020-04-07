//
//  RemoveLocation.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation
extension LocationService {
    enum RemoveLocation {
        struct Request {
            let locationId: String
        }
        
        struct SuccessResponse: Decodable {
            let status: Bool
        }
        enum ErrorResponse: Error {
            case genericError(_ message: String)
        }
    }
}

//
//  AddNewLocation.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 8.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation
extension LocationService {
    enum AddNewLocation {
        struct Request: Encodable {
            let id: String
            let name: String
            let status: String
            let temperature: Int
        }
        
        struct SuccessResponse: Decodable {
            let id: String
            let name: String
            let status: Status
            let temperature: Int
        }
        
        enum ErrorResponse: Error {
            case genericError(_ message: String)
        }
    }
}

extension LocationService.AddNewLocation.SuccessResponse {
    enum Status: String, Codable, CaseIterable {
        case cloudy = "CLOUDY"
        case sunny = "SUNNY"
        case mostlySunny = "MOSTLY_SUNNY"
        case partlySunnyRain = "PARTLY_SUNNY_RAIN"
        case thunderCloudAndRain = "THUNDER_CLOUD_AND_RAIN"
        case tornado = "TORNADO"
        case barelySunny = "BARELY_SUNNY"
        case lightening = "LIGHTENING"
        case snowCloud = "SNOW_CLOUD"
        case rainy = "RAINY"
        case partlySunny = "PARTLY_SUNNY"
    }
}


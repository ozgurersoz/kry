//
//  LocationServiceTests.swift
//  CodeTestTests
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import XCTest
@testable import CodeTest

class LocationServiceTests: XCTestCase {
    func testLocationService_fetchLocations_SuccessfulResponse() {
        let expectation = self.expectation(description: "search")
        makeMockRequest(
            responseObject: LocationService.FetchLocations.SuccessResponse.self,
            statusCode: 200,
            json: jsonData
        ) { (result) in
            if case let Result.success(value) = result {
                XCTAssertEqual(value.locations.count, 11)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        

        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLocationService_removeLocation_SuccessfullResponse() {
        let expectation = self.expectation(description: "remove")
        let session = URLSessionMock(statusCode: 200, data: nil)
        let manager = NetworkManager(urlSession: session)
        
        let urlRequest = URLRequest(url: URL(string: "http://mockapi.kry.io")!)
        manager.requestWithoutResponseData(urlRequest) { (result) in
            if case let Result.success(value) = result {
                XCTAssertEqual(value, true)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func makeMockRequest<ResponseModel: Decodable>(
        responseObject: ResponseModel.Type,
        statusCode: Int,
        json: String? = nil,
        then handler: @escaping (Result<ResponseModel, NetworkError>) -> Void) {
        
        let data = json?.data(using: .utf8)!
        let session = URLSessionMock(statusCode: 200, data: data)
        let manager = NetworkManager(urlSession: session)
        
        let urlRequest = URLRequest(url: URL(string: "http://mockapi.kry.io")!)
        manager.request(
            urlRequest,
            responseObject: ResponseModel.self
        ) { (result) in
            handler(result)
        }
    }

    let jsonData =
    """
        {
            "locations": [
            {
                "id": "1",
                "name": "Stockholm",
                "status": "CLOUDY",
                "temperature": 20
            },
            {
                "id": "2",
                "name": "Istanbul",
                "status": "SUNNY",
                "temperature": 20
            },
            {
                "id": "3",
                "name": "New York",
                "status": "MOSTLY_SUNNY",
                "temperature": 20
            },
            {
                "id": "4",
                "name": "DC",
                "status": "PARTLY_SUNNY_RAIN",
                "temperature": 20
            },
            {
                "id": "5",
                "name": "Los Angeles",
                "status": "THUNDER_CLOUD_AND_RAIN",
                "temperature": 20
            },
            {
                "id": "6",
                "name": "Paris",
                "status": "TORNADO",
                "temperature": 20
            },
            {
                "id": "7",
                "name": "Berlin",
                "status": "BARELY_SUNNY",
                "temperature": 20
            },
            {
                "id": "8",
                "name": "Turin",
                "status": "LIGHTENING",
                "temperature": 20
            },
            {
                "id": "9",
                "name": "Roma",
                "status": "SNOW_CLOUD",
                "temperature": 20
            },
            {
                "id": "10",
                "name": "Madrid",
                "status": "RAINY",
                "temperature": 20
            },
            {
                "id": "11",
                "name": "İzmir",
                "status": "PARTLY_SUNNY",
                "temperature": 20
            }
        ]
    }
    """
}

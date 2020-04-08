//
//  LocationServiceLogic.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 7.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

protocol LocationServiceLogic {
    func fetchLocations(_ request: LocationService.FetchLocations.Request,
                        then handler: @escaping (Result<LocationService.FetchLocations.SuccessResponse, LocationService.FetchLocations.ErrorResponse>) -> Void)
    func removeLocation(_ request: LocationService.RemoveLocation.Request)
}


class LocationService: LocationServiceLogic {
    var manager = NetworkManager(urlSession: URLSession(configuration: .default))
    
    func fetchLocations(_ request: FetchLocations.Request,
                        then handler: @escaping (Result<FetchLocations.SuccessResponse, FetchLocations.ErrorResponse>) -> Void) {
        
        guard let urlRequest = try? URLRequest.prepareForRequest(
            to: "/locations",
            method: .get,
            headers: ["X-Api-Key": SessionManager.apiKey]
        ) else {
            return handler(.failure(.genericError("URLRequest is wrong")))
        }
        
        manager.request(urlRequest, responseObject: LocationService.FetchLocations.SuccessResponse.self) { [weak self] (result) in
            guard let self: LocationService = self else { return }
            switch result {
            case .success(let response):
                self.cacheLocations(response)
                handler(.success(response))
            case .failure(let error):
                guard let cachedLocations = self.fetchCachedLocations() else {
                    return handler(.failure(.genericError(error.message)))
                }
                handler(.success(cachedLocations))
            }
        }
    }
    
    func removeLocation(_ request: RemoveLocation.Request) {
        guard let urlRequest = try? URLRequest.prepareForRequest(
            to: "/locations/\(request.locationId)",
            method: .delete,
            headers: ["X-Api-Key": SessionManager.apiKey]
        ) else {
            return
        }
        
        manager.requestWithoutResponseData(urlRequest) { _ in }
    }
}

private extension LocationService {
    func cacheLocations(_ locations: FetchLocations.SuccessResponse) {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(locations) else {
            return
        }
        UserDefaults.standard.set(jsonData, forKey: "locations")
    }
    
    func fetchCachedLocations() -> FetchLocations.SuccessResponse? {
        guard let data = UserDefaults.standard.data(forKey: "locations") else {
            return nil
        }
        let jsonDecoder = JSONDecoder()
        guard let decodedResponse = try? jsonDecoder.decode(FetchLocations.SuccessResponse.self, from: data) else {
            return nil
        }
        return decodedResponse
    }
}

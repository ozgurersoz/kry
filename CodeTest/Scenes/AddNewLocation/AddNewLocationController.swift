//
//  AddNewLocationController.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 8.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation
protocol AddNewLocationViewLogic {
    func navigateToBack()
    func displayError(_ message: String)
}

protocol AddNewLocationControllerDelegate: class {
    func reloadData()
}
class AddNewLocationController {
    var view: AddNewLocationViewLogic?
    private var locationService: LocationServiceLogic?
    weak var delegate: AddNewLocationControllerDelegate?
    
    init(locationService: LocationServiceLogic) {
        self.locationService = locationService
    }

    internal func bind(view: AddNewLocationViewLogic) {
        self.view = view
    }
}


extension AddNewLocationController {
    func saveLocation(id: String, city: String, status: String, temperture: String) {
        guard let temperture = Int(temperture) else {
            return
        }
        let request = LocationService.AddNewLocation.Request(id: id, name: city, status: status, temperature: temperture)
        locationService?.addNewLocation(request, then: { [weak self] (result) in
            guard let self: AddNewLocationController = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.reloadData()
                self.view?.navigateToBack()
            case .failure(let error):
                switch error {
                case .genericError(let message):
                    self.view?.displayError(message)
                }
            }
        })
    }
}

//
//  AddNewLocationControllerTests.swift
//  CodeTestTests
//
//  Created by Özgür Ersöz on 8.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import XCTest
@testable import CodeTest

class AddNewLocationControllerTests: XCTestCase {
    var viewController: AddNewLocationViewController!
    var controller: AddNewLocationController!
    
    override func setUp() {
        super.setUp()
        let locationService = MockLocationService()
        controller = AddNewLocationController(locationService: locationService)
    }
    
    func testAddNewLocationController_saveButton_shouldCallRefreshAndReloadTableViewData() {
        let viewController = SpyAddNewLocationViewController()
        controller.bind(view: viewController)
        controller.saveLocation(id: "1", city: "City", status: "SUNNY", temperture: "19")
        
        XCTAssertTrue(viewController.navigateToBackCalled, "navigateToBackCalled should be true")
    }
}

extension AddNewLocationControllerTests {
    
    class SpyAddNewLocationViewController: AddNewLocationViewLogic {
        var navigateToBackCalled = false
        var displayErrorCalled = false
        
        func navigateToBack() {
            navigateToBackCalled = true
        }
        
        func displayError(_ message: String) {
            displayErrorCalled = true
        }
    }
}

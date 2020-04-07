//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import XCTest
@testable import CodeTest

class WeatherControllerTests: XCTestCase {
    var viewController: WeatherViewController!
    var controller: WeatherController!
    
    override func setUp() {
        super.setUp()
        let locationService = MockLocationService()
        controller = WeatherController(locationService: locationService)
    }
    
    func testWeatherController_bindView_shouldCallRefreshAndReloadTableViewData() {
        let viewController = SpyWeatherViewController()
        controller.bind(view: viewController)
        
        XCTAssertTrue(viewController.showEntriesCalled, "showEntriesCalled should be true")
    }
}

extension WeatherControllerTests {
    class MockLocationService: LocationServiceLogic {
        func fetchLocations(_ request: LocationService.FetchLocations.Request, then handler: @escaping (Result<LocationService.FetchLocations.SuccessResponse, LocationService.FetchLocations.ErrorResponse>) -> Void) {
            let response = LocationService.FetchLocations.SuccessResponse(
                locations: [
                    LocationService.FetchLocations.SuccessResponse.WeatherLocation(
                        id: "1",
                        name: "Stockholm",
                        status: LocationService.FetchLocations.SuccessResponse.WeatherLocation.Status(rawValue: "SUNNY")!,
                        temperature: 25
                    )
                ]
            )
            handler(.success(response))
        }
        
        func removeLocation(_ request: LocationService.RemoveLocation.Request) {}
    }
    
    class SpyWeatherViewController: WeatherView {
        var showEntriesCalled = false
        var displayErrorCalled = false
        
        func showEntries() {
            showEntriesCalled = true
        }
        
        func displayError(_ message: String) {
            displayErrorCalled = true
        }
    }
}

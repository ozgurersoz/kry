//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherView {
    func showEntries()
    func displayError(_ message: String)
}

class WeatherController {
    var view: WeatherView?
    private var locationService: LocationServiceLogic?
    public private(set) var entries: [WeatherLocation] = []

    init(locationService: LocationServiceLogic) {
        self.locationService = locationService
    }

    internal func bind(view: WeatherView) {
        self.view = view
        refresh()
    }
}

extension WeatherController {
    func refresh() {
        let request = LocationService.FetchLocations.Request() // Keep it for future
        locationService?.fetchLocations(request, then: { [weak self] (result) in
            guard let self: WeatherController = self else { return }
            switch result {
            case .success(let value):
                let locations = value.locations.map { location -> WeatherLocation in
                    let status = self.prepareLocationStatus(from: location.status)
                    return WeatherLocation(id: location.id, name: location.name, status: status, temperature: "\(location.temperature)ºC")
                }
                self.entries = locations
                self.view?.showEntries()
            case .failure(let error):
                switch error {
                case .genericError(let message):
                    self.view?.displayError(message)
                }
            }
        })
    }
    
    func removeLocationFromApi(with locationId: String) {
        let request = LocationService.RemoveLocation.Request(locationId: locationId)
        locationService?.removeLocation(request)
    }
    
    func removeLocation(at index: Int) {
        let locationId = entries[index].id
        removeLocationFromApi(with: locationId)
        self.entries.remove(at: index)
    }
}

private extension WeatherController {
    func prepareLocationStatus(from status: LocationService.FetchLocations.SuccessResponse.WeatherLocation.Status) -> WeatherLocation.Status {
        let emoji = prepareEmoji(from: status)
        let backgroundColor = prepareBackgroundColor(from: status)
        
        return WeatherLocation.Status(emoji: emoji, backgroundColor: backgroundColor)
    }
    
    func prepareEmoji(from status: LocationService.FetchLocations.SuccessResponse.WeatherLocation.Status) -> String {
        switch status {
        case .cloudy: return "☁️"
        case .sunny: return "☀️"
        case .mostlySunny: return "🌤"
        case .partlySunnyRain: return "🌦"
        case .thunderCloudAndRain: return "⛈"
        case .tornado: return "🌪"
        case .barelySunny: return "🌥"
        case .lightening: return "🌩"
        case .snowCloud: return "🌨"
        case .rainy: return "🌧"
        case .partlySunny: return "🌤"
        }
    }

    func prepareBackgroundColor(from status: LocationService.FetchLocations.SuccessResponse.WeatherLocation.Status) -> UIColor {
        switch status {
        case .cloudy, .rainy, .snowCloud: return .lightGray
        case .tornado, .thunderCloudAndRain, .lightening: return UIColor(red: 255 / 255, green: 113 / 255, blue: 113 / 255, alpha: 1)
        case .sunny, .mostlySunny, .barelySunny, .partlySunnyRain, .partlySunny: return UIColor(red: 114 / 255, green: 168 / 255, blue: 255 / 255, alpha: 1)
        }
    }
}

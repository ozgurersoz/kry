//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

struct WeatherLocation {
    let id: String
    let name: String
    let status: Status
    let temperature: String
}

extension WeatherLocation {
    struct Status {
        let emoji: String
        let backgroundColor: UIColor
    }
}

func ==(lhs: WeatherLocation, rhs: WeatherLocation) -> Bool {
    return lhs.id == rhs.id
}

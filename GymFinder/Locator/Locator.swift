
import CoreLocation

enum Result <T> {
    case Success(T)
    case Failure(Error)
}

class Locator: NSObject, CLLocationManagerDelegate {

    static let shared: Locator = Locator()

    typealias Callback = (Result <Locator>) -> Void

    var requests: Array <Callback> = Array <Callback>()

    var location: CLLocation? { return sharedLocationManager.location  }

    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        // ...
        return newLocationmanager
    }()

    // MARK: - Authorization

    class func authorize() { shared.authorize() }
    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }

    // MARK: - Helpers

    func locate(callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }

    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }

    // MARK: - Delegate

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        for request in self.requests { request(.Failure(error)) }
        self.reset()
    }

    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        for request in self.requests { request(.Success(self)) }
        self.reset()
    }
}
